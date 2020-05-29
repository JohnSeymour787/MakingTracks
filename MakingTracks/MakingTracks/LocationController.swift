//
//  LocationController.swift
//  MakingTracks
//
//  Created by John on 5/28/20.
//  Copyright © 2020 John. All rights reserved.
//
//  Purpose: To control this app's use of location services through the Core Location framework
//           and provide coordinates to a LocationControllerDelegate method, if needed.
//           Presently, only uses location data for the mapView in StationMapViewController to
//           follow.

import Foundation
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate
{
    //MARK:Properties
    
    //Singleton class
    static let shared = LocationController()

    var delegate: LocationControllerDelegate?
    
    private let locationManager = CLLocationManager()
    
    //Assume by default that the user is moving when they launch the app to get slightly better location accuracy.
    private var userIsMoving = true
    
    //MARK: Private Methods
    
    private override init()
    {
        super.init()
        locationManager.delegate = self
    }
    
    ///One time configuration of the LocationManager before also starting services.
    private func initialiseLocationConfiguration()
    {
        //Check for location hardware support
        if CLLocationManager.locationServicesEnabled()
        {
            //Expect the user mostly to be walking, so will auto-pause location services if not enough movement for this activity is detected
            locationManager.activityType = .fitness
            
            locationManager.allowsBackgroundLocationUpdates = false
            
            //Difference in distance from last 'didUpdateLocations' delegate method call, before that delegate method is called again
            locationManager.distanceFilter = Constants.LocationConstants.DefaultDistanceFilter
            setUpdateRateWhenMoving()
        }
    }
    
    ///Configures the locationManager's desired accuracy to a higher rate as the user is now thought to be moving. Assumes the locationManager is currently stopped from updating the location.
    private func setUpdateRateWhenMoving()
    {
        //If was false before (after future calls, it can be)
        userIsMoving = true
        
        //Re-enable auto-pausing of location updates for the activity type
        locationManager.pausesLocationUpdatesAutomatically = true
        
        //Increasing tracking accuracy now that user is moving
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.startUpdatingLocation()
    }
    
    //MARK: Public Methods
    
    ///Checks if location tracking is possible on this device and that the app is authorised to do so, otherwise, attempts to acquire permissions. If authorisation is already granted, will begin tracking immediately.
    func prepareLocationServices()
    {
        //If global location services are turned off for the device, try to start using them
        //anyway to possibly send an iOS message to the user to enable them.
        if !CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
            return
        }
    
        //Checking current authorisation status for this app
        switch CLLocationManager.authorizationStatus()
        {
            //If not set, try to get 'When In Use' authorisation
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            
            //If already have authorisation, begin the location tracking
            case .authorizedWhenInUse:
                initialiseLocationConfiguration()
            
            default:
                break
        }
    }
    
    ///Stops the location tracking services.
    func stopLocationServices()
    {
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: Delegate Methods
    
    //Writes error message if location manager fails.
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }

    //Starts location tracking if user grants 'When In Use' authorisation
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse
        {
            initialiseLocationConfiguration()
        }
    }
    
    //When updates are auto-paused, we assume that the user is no longer moving much
    internal func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager)
    {
        userIsMoving = false
        
        //Disable future pauses, but set the desired accuracy a little lower to save battery life, then begin the updates again.
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startUpdatingLocation()
    }

    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last!
        let accuracy = location.horizontalAccuracy
        
        //If accuracy is out of range then dont do anything with the location data
        if accuracy < 0 || accuracy > Constants.LocationConstants.DesiredAccuracy
        {
            return
        }

        //If user was previously not moving before and this is the first accurate track of them moving beyond the distance filter, then re-enable higher-precision tracking
        if !userIsMoving
        {
            locationManager.stopUpdatingLocation()
            setUpdateRateWhenMoving()
        }
    }
}
