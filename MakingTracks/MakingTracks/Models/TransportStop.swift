//
//  StopMapAnnotation.swift
//  MakingTracks
//
//  Created by John on 5/21/20.
//  Copyright © 2020 John. All rights reserved.
//
//  Purpose: Represents a transport stop's basic details and allows it to be viewed on a map.

import Foundation
import MapKit

class TransportStop: NSObject, MKAnnotation
{
    let coordinate: CLLocationCoordinate2D
    let name: String
    let suburb: String
    let stopID: Int
    let routeType: TransportType
    let distance: Double
    
    init(name: String, suburb: String, stopID: Int, routeType: TransportType, coordinate: CLLocationCoordinate2D, distance: Double)
    {
        self.name = name
        self.suburb = suburb
        self.stopID = stopID
        self.routeType = routeType
        self.coordinate = coordinate
        self.distance = distance
        
        super.init()
    }
    
    //Title displayed to the user on the MapKit annotation view callout
    var title: String?
    {
        return name
    }
    
    ///Takes a serialised raw JSON 'Any' object and attempts to convert to an array of class instances. Returns nil if cannot find stops JSON array or returns empty array if cannot find stops. Otherwise, returns array of class instances.
    static func decodeToArray(rawJSON: Any) -> [TransportStop]?
    {
        //Need to get the inner "stops" array from the JSON server response
        guard
            let jsonOuterObject = rawJSON as? [String: Any],
            let stopsArray = jsonOuterObject["stops"] as? [Any]
        else
        {
            return nil
        }

        var result: [TransportStop] = []
        var itemToAdd: TransportStop
        
        for element in stopsArray
        {
            if let stop = element as? [String: Any]
            {
                //If any key-value conversion fails, the object is not added to the array
                if let name = stop["stop_name"] as? String,
                   let suburb = stop["stop_suburb"] as? String,
                   let stopID = stop["stop_id"] as? Int,
                   let routeTypeRaw = stop["route_type"] as? Int,
                   let routeType = TransportType(rawValue: routeTypeRaw),
                   let lat = stop["stop_latitude"] as? Double,
                   let long = stop["stop_longitude"] as? Double
                {
                    //If calling NetworkController .getStops or .getAllStops then this will be nil. Converting Distance in meters to kilometers
                    let distance = (stop["stop_distance"] as? Double ?? 0.0)/1000
                    
                    itemToAdd = TransportStop(name: name, suburb: suburb, stopID: stopID, routeType: routeType, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), distance: distance)
                    result.append(itemToAdd)
                }
            }
        }
        
        return result
    }
}
