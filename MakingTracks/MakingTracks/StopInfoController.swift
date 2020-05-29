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
    func PTVAPIStatusUpdate(healthCheck: PTVAPIHealthCheckModel)
    {
        
    }
    
    func dataDecodingComplete(_ decodedData: [Any])
    {
        departuresArray = decodedData as? [DepartureDetails]
        
        if departuresArray != nil
        {
            delegate?.downloadComplete()
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

