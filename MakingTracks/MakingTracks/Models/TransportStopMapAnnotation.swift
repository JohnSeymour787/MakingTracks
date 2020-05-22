//
//  StopMapAnnotation.swift
//  MakingTracks
//
//  Created by user169372 on 5/21/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import MapKit

class TransportStopMapAnnotation: NSObject, MKAnnotation
{
    let coordinate: CLLocationCoordinate2D
    let name: String
    let suburb: String
    let stopID: Int
    let routeType: TransportType
    
    init(name: String, suburb: String, stopID: Int, routeType: TransportType, coordinate: CLLocationCoordinate2D)
    {
        self.name = name
        self.suburb = suburb
        self.stopID = stopID
        self.routeType = routeType
        self.coordinate = coordinate
    }
    
    static func decodeToArray(rawJSON: Any) throws -> [TransportStopMapAnnotation]?
    {
        guard
            let jsonOuterObject = rawJSON as? [String: Any],
            let stopsArray = jsonOuterObject["stops"] as? [Any]
        else
        {
            return nil
        }

        var result: [TransportStopMapAnnotation] = []
        var itemToAdd: TransportStopMapAnnotation
        
        for element in stopsArray
        {
            if let stop = element as? [String: Any]
            {
                if let name = stop["stop_name"] as? String,
                   let suburb = stop["stop_suburb"] as? String,
                   let stopID = stop["stop_id"] as? Int,
                   let routeType = stop["route_type"] as? TransportType,
                   let lat = stop["stop_latitude"] as? Double,
                   let long = stop["stop_longitude"] as? Double
                {
                    itemToAdd = TransportStopMapAnnotation(name: name, suburb: suburb, stopID: stopID, routeType: routeType, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                    result.append(itemToAdd)
                }

            }
        }
        
        return result
    }
}
