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
    
    var delegate: LocationControllerDelegate?
    private let locationManager = CLLocationManager()
    private var userIsMoving = true
    
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
                locationManager.activityType = .fitness
                locationManager.allowsBackgroundLocationUpdates = false
                locationManager.distanceFilter = Constants.LocationConstants.DefaultDistanceFilter
                setUpdateRateWhenMoving()
            }
            
        }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager)
    {
        userIsMoving = false
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }
        
    private func setUpdateRateWhenMoving()
    {
        userIsMoving = true
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }

        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last!
        let accuracy = location.horizontalAccuracy
        if accuracy < 0 || accuracy > Constants.LocationConstants.DesiredAccuracy
        {
            return
        }

        if !userIsMoving
        {
            locationManager.stopUpdatingLocation()
            setUpdateRateWhenMoving()
        }
    
            
    }
    
    func stopLocationServices()
    {
        locationManager.stopUpdatingLocation()
    }
    
}
