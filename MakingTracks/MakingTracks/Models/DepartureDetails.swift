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
    
    ///Returns a string of the departure date in h:mm am/pm format
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
    
    ///Converts a raw JSON Any object to an array of class instances representing an upcoming departure from a stop.
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
        
        //Formatter to convert a UTC date string into a Date object
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
    
    ///Class instance attempts to convert a serialised JSON object into a JSON dictionary containing a direction_name key. Uses this to update its directionString property. Returns direction name if successful, to allow for future caching in NetworkController.
    func updateDirectionNameFrom(rawJSON: Any) -> String?
    {
        //Should be at least 1 element in an existing 'directions' array
        guard
            let jsonOuterObject = rawJSON as? [String: Any],
            let directionsArray = jsonOuterObject["directions"] as? [Any],
            directionsArray.count >= 0
        else
        {
            return nil
        }
        
        //The first element will contain the valid direction name
        if let firstElement = directionsArray.first as? [String: Any]
        {
            directionString = firstElement["direction_name"] as? String
            return directionString
        }
        
        return nil
    }
}
