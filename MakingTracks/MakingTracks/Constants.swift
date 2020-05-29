//
//  Constants.swift
//  MakingTracks
//
//  Created by user169372 on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import CoreLocation

struct Constants
{
    struct LocationSearch
    {
        ///Maximum expected stops possible for a single transport type across the state
        static let MaxForAllPossibleResults = 1000
        
        ///Maximum distance from the Melbourne CBD (in meters) to cover the entire state of Victoria for 'nearby' search
        static let MaxDistanceForAllResults = 600000
        
        ///Default search radius for nearby stops searches
        static let DefaultDistanceSearch = 3000
    }
    
    struct APIEndPoints
    {
        ///Base URL for a health check request to the API to test connection and signature key generation
        static let APIHealthCheck = "https://timetableapi.ptv.vic.gov.au/v2/healthcheck"
        
        ///Base URL for retrieving stops near a location. Requires latitude and longitude parameters, separated by a comma
        static let StopsNearLocation = "https://timetableapi.ptv.vic.gov.au/v3/stops/location/"
        
        
    }
    
    struct LocationConstants
    {
        ///CLLocationCoordinate2D value for precisely the center of Melbourne
        static let MelbourneCDB = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        
        static let DefaultDistanceFilter = 10.0
        
        static let DesiredAccuracy = 50.0
    }
        
    
    
}
