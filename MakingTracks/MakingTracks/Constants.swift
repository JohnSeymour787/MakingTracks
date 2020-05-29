//
//  Constants.swift
//  MakingTracks
//
//  Created by John on 5/15/20.
//
//  Purpose: Nested-struct class of static constants for all app needs.

import Foundation
import CoreLocation
import MapKit

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
        
        static let DeparturesFromStop = "https://timetableapi.ptv.vic.gov.au/v3/departures/"
    }
    
    struct MapViewConstants
    {
        ///Default camera position for the MapView. Camera is located 5000 m above the center of the Melbourne CBD
        static let DefaultCamera = MKMapCamera(lookingAtCenter: LocationConstants.MelbourneCDB, fromDistance: 5000, pitch: 0, heading: 0)
    }
    
    struct LocationConstants
    {
        ///CLLocationCoordinate2D value for precisely the center of Melbourne
        static let MelbourneCDB = CLLocationCoordinate2D(latitude: -37.8136, longitude: 144.9631)
        
        ///Default change in distance the device must be moved before new 'DidUpdateLocations' delegate method is called
        static let DefaultDistanceFilter = 10.0
        
        ///Preferred accuracy to accept for 'DidUpdateLocations' to use the new location data
        static let DesiredAccuracy = 50.0
    }
        
    
    
}
