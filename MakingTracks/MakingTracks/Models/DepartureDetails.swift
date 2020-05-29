//
//  DepartureDetails.swift
//  MakingTracks
//
//  Created by user169372 on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation

class DepartureDetails
{
    let stopID: Int?
    var routeID: Int?
    var runID: Int?
    var directionID: Int?
    
    var scheduledDepartureTime: Date?
    var atPlatform: Bool?
    var platformNumber: Int?
    
    init()
    {
        stopID = 0
    }
    
    
}
