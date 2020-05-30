//
//  StopInfoController.swift
//  MakingTracks
//
//  Created by John on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import UIKit

class StopInfoController: NSObject, NetworkControllerDelegate
{
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
            
            if completedDirectionUpdates == departuresArray?.count
            {
                //Tell the ScheduledServicesViewController to reload its table data
                delegate?.downloadComplete()
                
                //Don't expect any more calls to this if block anymore
                completedDirectionUpdates = 0
            }
            
            return
        }
        
        departuresArray = decodedData as? [DepartureDetails]

        guard departuresArray != nil else
        {
            return
        }
        
        for departure in departuresArray!
        {
            NetworkController.shared.updateDirectionName(for: departure)
        }
    }
    
    override init()
    {
        super.init()
        
        
    }
    var delegate: UpdateTableDataDelegate?
    var departuresArray: [DepartureDetails]?
    //stopDetails
    
    func beginStopsDataRetrieval(stopID: Int)
    {
        NetworkController.shared.delegate = self
        NetworkController.shared.getDeparturesFor(stopID: stopID)
    }
    
}


extension StopInfoController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return departuresArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departureDetailsCell", for: indexPath) as! DepartureDetailsCell
        
        if departuresArray != nil
        {
            cell.setLabels(details: departuresArray![indexPath.row])
        }
        
        return cell
    }
    
    
}

