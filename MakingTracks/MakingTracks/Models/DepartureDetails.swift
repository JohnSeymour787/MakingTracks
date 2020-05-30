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
    var directionString: String?
    
    let scheduledDepartureTime: Date
    let atPlatform: Bool
    let platformNumber: Int
    
    var calculatedRemainingTime: Int
    {
        //Converting time difference in seconds to minutes
        return Int(scheduledDepartureTime.timeIntervalSinceNow / 60.0)
    }
    
    var departureTimeString: String
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "h:mm a"
        //Cannot use this because working on a remote desktop based in San Francisco!
        //formatter.timeZone = .current
        formatter.timeZone = TimeZone(identifier: "Australia/Melbourne")
        
        let currentTime = formatter.string(from: scheduledDepartureTime)
        
        return currentTime
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
    
    func updateDirectionNameFrom(rawJSON: Any)
    {
        guard
            let jsonOuterObject = rawJSON as? [String: Any],
            let directionsArray = jsonOuterObject["directions"] as? [Any],
            directionsArray.count >= 0
        else
        {
            return
        }
        
        if let firstElement = directionsArray.first as? [String: Any]
        {
            directionString = firstElement["direction_name"] as? String
        }
    }
}
