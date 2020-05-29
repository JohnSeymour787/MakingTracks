//
//  StopInfoController.swift
//  MakingTracks
//
//  Created by John on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import UIKit

class StopInfoController: NSObject
{
    //departuresArray
    //stopDetails
    
    
}


extension StopInfoController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departureDetailsCell", for: indexPath) as! DepartureDetailsCell
        
        //cell.details()
        
        return cell
    }
    
    
}

