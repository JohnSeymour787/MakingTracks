//
//  LocationController.swift
//  MakingTracks
//
//  Created by user169372 on 5/28/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate
{
    //Singleton class
    static let shared = LocationController()
    private override init()
    {
        super.init()
        locationManager.delegate = self
    }
    
    private let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            //
        }
        
    func prepareLocationServices()
    {
        //If global location services are turned off for the phone, try to start using them
        //anyway to possibly send an iOS message to the user to enable them.
        if !CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
            return
        }
    
             
        // */
        //V Need to check this everytime ViewDidLoad
        //Checking current authorisation status for this app
        switch CLLocationManager.authorizationStatus()
        {
            //If not set, try to set 'When In Use' authorisation
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            //If already have authorisation, begin the location tracking
            case .authorizedWhenInUse:
                beginLocationServices()
            
            default:
                break
        }
    }
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
        {
            if status == .authorizedWhenInUse
            {
                beginLocationServices()
            }
        }
        
        private func beginLocationServices()
        {
            //Check for location hardware support
            if CLLocationManager.locationServicesEnabled()
            {
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                locationManager.startUpdatingLocation()
            }
            
        }
        
        func stopLocationServices()
        {
            locationManager.stopUpdatingLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let location = locations.last!
            let coordinate = location.coordinate
        
            NetworkController.shared.getNearbyStops(near: coordinate)
            mapView.camera.centerCoordinate = coordinate
            
            //mapView.camera = mapView.camera
            
        }
    
}
