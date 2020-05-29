//
//  NetworkController.swift
//  MakingTracks
//
//  Created by John on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//
//  Purpose: To facilitate all app API requests through a singleton class instance with one
//           URLSession instance.

import Foundation
import CoreLocation
import UIKit
///Singleton Class for all app API requests
class NetworkController
{
    private init()
    {
    }
    
    //MARK: Properties
    
    //Singleton class
    static let shared = NetworkController()

    var delegate: NetworkControllerDelegate?
    
    private lazy var session: URLSession =
    {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()
    
    //MARK: Private Methods
    
    ///Standard URLSession.DataTask completion handler parameter values check. Ensures that no error, reponse is good HTTP and with MIME type of application/json, and that data is not nil.
    private func standardParameterCheck(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Bool
    {
        if error != nil
        {
            print(error.debugDescription)
            return false
        }
        
        if data == nil
        {
            return false
        }
        
        guard let httpResponse = response as? HTTPURLResponse,        (200...299).contains(httpResponse.statusCode) else
        {
            return false
        }
        
        //After all prior checks, must finally ensure that we are dealing with JSON data
        return httpResponse.mimeType == "application/json"
    }
    
    ///Prepares a URLSessionDataTask from a URL string specifically for JSONSerialisation and conversion to an array of TransportStopMapAnnotation objects. Sets up the specific completion handler for this. This method is what actually calls the 'addMapAnnotations' NetworkController delegate method when complete.
    private func dataTaskForAPIStops(urlString: String) -> URLSessionDataTask?
    {
        guard let url: URL = PTVAPISupportClass.generateURL(withDevIDAndKey: urlString) else
        {
            return nil
        }
           
        //Set up data task and its completion handler
        let result = session.dataTask(with: url)
        {   data, response, error in
            guard self.standardParameterCheck(data, response, error) else
            {
                return
            }
               
            if let jsonSerialised = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            {
                if let stopsArray = TransportStopMapAnnotation.decodeToArray(rawJSON: jsonSerialised)
                {
                    self.delegate?.dataDecodingComplete(stopsArray)
                }
            }
        }
           
        return result
    }
    
    //MARK: Public Methods
    
    ///Calls the 'HealthCheck' API endpoint to get status details about the API servers. Calls the 'PTVAPIStatusUpdate' NetworkControllerDelegate method when complete.
    public func APIhealthCheck()
    {
        guard let url: URL = PTVAPISupportClass.generateURL(withDevIDAndKey: Constants.APIEndPoints.APIHealthCheck) else
        {
            return
        }

        let task = session.dataTask(with: url)
        {
            data, response, error in
        //  {
                guard self.standardParameterCheck(data, response, error) else
                {
                    return
                }
            
                let decoder = JSONDecoder()
            
                //Converting to the Decodable-conforming PTVAPIHealthCheckModel class
                if let APIHealth = try? decoder.decode(PTVAPIHealthCheckModel.self, from: data!)
                {
                    self.delegate?.PTVAPIStatusUpdate(healthCheck: APIHealth)
                }
        //  }
        }
        
        task.resume()
    }
    
    ///Retrieves all stops in the state of Victoria for a single transport type. Calls 'addMapAnnotations' NetworkController delegate method when complete.
    func getAllStops(transportType: TransportType = .Train)
    {
        //API request still requires a location, so do a stops request from the center of Melbourne.
        let coordinate = Constants.LocationConstants.MelbourneCDB
        
        var APIURL = Constants.APIEndPoints.StopsNearLocation + "\(coordinate.latitude),\(coordinate.longitude)?route_types=\(transportType)"
        //Adding the optional parameters with corresponding values to get all stops across the state.
        APIURL += "&max_results=\(Constants.LocationSearch.MaxForAllPossibleResults)"
        APIURL += "&max_distance=\(Constants.LocationSearch.MaxDistanceForAllResults)"
        
        //Generate the URL object from the string and set up the URLSessionDataTask
        if let task = dataTaskForAPIStops(urlString: APIURL)
        {
            task.resume()
        }
    }
    
    ///Calls the API to retrieve up to 30 stops of a given transport type near a coordinate location. Calls 'addMapAnnotations' NetworkController delegate method when complete.
    func getStops(near coordinate: CLLocationCoordinate2D, transportType: TransportType = .Train)
    {
        let APIURL = Constants.APIEndPoints.StopsNearLocation + "\(coordinate.latitude),\(coordinate.longitude)?route_types=\(transportType)&max_distance=\(Constants.LocationSearch.DefaultDistanceSearch)"
        

        if let task = dataTaskForAPIStops(urlString: APIURL)
        {
            task.resume()
        }
    }
    
    func getDeparturesFor(stopID: Int, routeType: TransportType = .Train)
    {
        let APIURL = Constants.APIEndPoints.DeparturesFromStop + "route_type/\(routeType)/stop/\(stopID)?max_results=1"
        
        guard let url: URL = PTVAPISupportClass.generateURL(withDevIDAndKey: APIURL) else
        {
            return
        }
        
        let task = session.dataTask(with: url)
        {   data, response, error in
            guard self.standardParameterCheck(data, response, error) else
            {
                return
            }
            
            if let jsonSerialised = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            {
                if let departuresArray = DepartureDetails.decodeToArray(rawJSON: jsonSerialised)
                {
                    self.delegate?.dataDecodingComplete(departuresArray)
                }
            }
        }
        
        task.resume()
    }
    
    func updateDirectionName(for departureDetails: DepartureDetails, transportType: TransportType = .Train)
    {
        let APIURL = Constants.APIEndPoints.DirectionDetailsForRouteType + "\(departureDetails.directionID)/route_type/\(transportType)"
        
        guard let url: URL = PTVAPISupportClass.generateURL(withDevIDAndKey: APIURL) else
        {
            return
        }
        
        let task = session.dataTask(with: url)
        {   data, response, error in
            guard self.standardParameterCheck(data, response, error) else
            {
                return
            }

            if let jsonSerialised = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            {
                departureDetails.updateDirectionNameFrom(rawJSON: jsonSerialised)
                self.delegate?.dataDecodingComplete(["Done"])
            }
        }
        
        task.resume()
    }
}
