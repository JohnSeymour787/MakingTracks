//
//  StopInfoController.swift
//  MakingTracks
//
//  Created by John on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//
//  Purpose: Central controller between the ScheduledServicesViewController and the StopDetailsViewController. Retrieves and contains all details of a specific stop, as well as the upcoming departures in all directions.


import Foundation
import UIKit

class StopInfoController: NSObject, NetworkControllerDelegate
{
    ///Remembers the number of elements in the departuresArray that have updated their direction name properties. Only when this value matches the size of the array are all updates complete and this controller should then signal the ScheduledServicesViewController to load its tableView data.
    private var completedDirectionUpdates = 0
    
    func PTVAPIStatusUpdate(healthCheck: PTVAPIHealthCheckModel)
    {
        
    }
    
    func dataDecodingComplete(_ decodedData: Any)
    {
        //If the NetworkController calls this delegate method with an empty string then one of the departure elements in the array has had its name updated
        if ((decodedData as? String) != nil)
        {
            completedDirectionUpdates += 1
            
            //All array elements now have proper direction string values
            if completedDirectionUpdates == departuresArray?.count
            {
                //Tell the ScheduledServicesViewController to reload its table data
                delegate?.downloadComplete()
                
                //Don't expect any more calls to this if block
                completedDirectionUpdates = 0
            }
            
            return
        }
        else if let stationDetails = decodedData as? StationDetails
        {
            stopDetails = stationDetails
            delegate?.downloadComplete()
            return
        }
        
        //Otherwise, the decodedData might be a new array of DepatureDetails instances
        departuresArray = decodedData as? [DepartureDetails]

        guard departuresArray != nil else
        {
            return
        }
        
        //Then need to make each element begin an API request (or use cache if available) to get its valid direction name string
        for departure in departuresArray!
        {
            NetworkController.shared.updateDirectionName(for: departure)
        }
    }
    

    var delegate: UpdateTableDataDelegate?
    private var departuresArray: [DepartureDetails]?
    var stopDetails: StationDetails?
    
    ///Calls the API to get an array of DepartureDetails for the given stop
    func beginStopDataRetrieval(stopID: Int, transportType: TransportType)
    {
        //Get the departures details which are immediately needed for this screen
        NetworkController.shared.delegate = self
        NetworkController.shared.getDeparturesFor(stopID: stopID, transportType: transportType)
        
        //Also, on another Queue, get the specific details for this stop, to save time later if 'Station Details' button is pressed
        DispatchQueue.global(qos: .userInitiated).async
        {
            NetworkController.shared.getStopDetails(stopID: stopID, transportType: transportType)
        }
    }
}


extension StopInfoController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departureDetailsCell", for: indexPath) as! DepartureDetailsCell
        
        if departuresArray != nil
        {
            //Sets UILabel values for this cell based on the various properties of the current departure
            cell.setLabels(details: departuresArray![indexPath.section])
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return departuresArray?.count ?? 0
    }
}

