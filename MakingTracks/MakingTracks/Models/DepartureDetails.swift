//
//  DepartureDetails.swift
//  MakingTracks
//
//  Created by John on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation

class DepartureDetails
{
    let stopID: Int
    let routeID: Int
    //Maybe don't need this one
    var runID: Int?
    let directionID: Int
    
    let scheduledDepartureTime: Date
    let atPlatform: Bool
    let platformNumber: Int
    
    var calculatedRemainingTime: Int
    {
        return Int(scheduledDepartureTime.timeIntervalSinceNow / 60.0)
    }
    
    init(_ stopID: Int, _ routeID: Int, _ directionID: Int, _ platformNumber: Int, _ atPlatform: Bool, _ departureTime: Date)
    {
        self.stopID = stopID
        self.routeID = routeID
        self.directionID = directionID
        self.platformNumber = platformNumber
        self.atPlatform = atPlatform
        self.scheduledDepartureTime = departureTime
    }
    
    static func decodeToArray(rawJSON: Any) -> [DepartureDetails]?
    {
        //Need to get the inner "departures" array from the JSON server response
        guard
            let jsonOuterObject = rawJSON as? [String: Any],
            let departuresArray = jsonOuterObject["departures"] as? [Any]
        else
        {
            return nil
        }
        
        var result: [DepartureDetails] = []
        var itemToAdd: DepartureDetails
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        for element in departuresArray
        {
            if let departure = element as? [String: Any]
            {
                //If any key-value conversion fails, the object is not added to the array
                if let stopID = departure["stop_id"] as? Int,
                   let routeID = departure["route_id"] as? Int,
                   let directionID = departure["direction_id"] as? Int,
                   let platformNumberString = departure["platform_number"] as? String,
                   let platformNumber = Int(platformNumberString),
                   let atPlatform = departure["at_platform"] as? Bool,
                   let utcTimeRaw = departure["scheduled_departure_utc"] as? String,
                   let utcTime = dateFormatter.date(from: utcTimeRaw)
                {
                    itemToAdd = DepartureDetails(stopID, routeID, directionID, platformNumber, atPlatform, utcTime)
                    
                    result.append(itemToAdd)
                }

            }
        }
        
        return result
    }
}

/*
private extension Date
{
    func minutesFromNow() -> Int
    {
        self.timeIntervalSinceNow
    }
}*/
