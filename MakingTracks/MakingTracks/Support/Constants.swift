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
        
        ///Base URL for retrieving upcoming departures from a given stop. Requires stop ID and route ID parameters.
        static let DeparturesFromStop = "https://timetableapi.ptv.vic.gov.au/v3/departures/"
        
        ///Base URL for retrieving all details, including name, of a direction, from a required direction ID parameter.
        static let DirectionDetailsForRouteType = "https://timetableapi.ptv.vic.gov.au/v3/directions/"
        
        ///Base URL to retrieve facility details for a stop. Requires stop ID and route_type. The latter must be Metro or Vline stop (route_type = 0 or 3). Also set stop_amenities, stop_accessibility, stop_contact, and stop_ticket parameters as true.
        static let StationDetails = "https://timetableapi.ptv.vic.gov.au/v3/stops/"
        
        ///Base URL to search for stops. Requires search term. Optional parameters includes route_types, latitude, longitude, include_outlets=false.
        static let StopSearch = "https://timetableapi.ptv.vic.gov.au/v3/search/"
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
        
    struct UIConstants
    {
        ///Represents the spacing between sections of a UITableView
        static let TableViewSectionSpacing = 20.0
        
        struct ColorConstants
        {
            static let MetroBlue = UIColor(displayP3Red: 0/255, green: 114/255, blue: 206/255, alpha: 1)
            static let TramGreen = UIColor(displayP3Red: 120/255, green: 190/255, blue: 32/255, alpha: 1)
            static let BusOrange = UIColor(displayP3Red: 255/255, green: 130/255, blue: 0/255, alpha: 1)
            static let VLinePurple = UIColor(displayP3Red: 127/255, green: 13/255, blue: 130/255, alpha: 1)
            static let NightBusBlue = UIColor(displayP3Red: 4/255, green: 28/255, blue: 44/255, alpha: 1)
        }
    }
    
}
