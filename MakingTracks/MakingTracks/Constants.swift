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
        ///CLLocationCoordinate2D value for precisely the center of Melbourne
        static let MelbourneCDB = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        
        ///Maximum expected stops possible for a single transport type across the state
        static let MaxForAllPossibleResults = 1000
        
        ///Maximum distance from the Melbourne CBD (in meters) to cover the entire state of Victoria for 'nearby' search
        static let MaxDistanceForAllResults = 600000
    }
    
    
}