//
//  NetworkController.swift
//  MakingTracks
//
//  Created by user169372 on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import CoreLocation

///Singleton Class for all app API requests
class NetworkController
{
    //Singleton class
    static let shared = NetworkController()
    private init()
    {
    }
    
    var delegate: NetworkControllerDelegate?
    
    private lazy var session: URLSession =
    {
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
    }()
    
    //*UPDATE RETURN TYPE*
    public func APIhealthCheck() -> Bool
    {
        guard let url: URL = PTVAPISupportClass.generateURL(withDevIDAndKey: Constants.APIEndPoints.APIHealthCheck) else
        {
            return false
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
            
                if let APIHealth = try? decoder.decode(PTVAPIHealthCheckModel.self, from: data!)
                {
                    self.delegate?.PTVAPIStatusUpdate(healthCheck: APIHealth)
                    print(APIHealth.securityTokenOK)
                }
        //  }
        }
        
        task.resume()
        
        return true
    }
    
    func getAllStops(transportType: TransportType = .Train)
    {
        let coordinate = Constants.LocationConstants.MelbourneCDB
        
        var APIURL = Constants.APIEndPoints.StopsNearLocation + "\(coordinate.latitude),\(coordinate.longitude)?route_types=\(transportType)"
        
        APIURL += "&max_results=\(Constants.LocationSearch.MaxForAllPossibleResults)"
        
        APIURL += "&max_distance=\(Constants.LocationSearch.MaxDistanceForAllResults)"
        
        if let task = dataTaskForAPIStops(urlString: APIURL)
        {
            task.resume()
        }
    }
    
    private func dataTaskForAPIStops(urlString: String) -> URLSessionDataTask?
    {
        guard let url: URL = PTVAPISupportClass.generateURL(withDevIDAndKey: urlString) else
        {
            return nil
        }
        
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
                    self.delegate?.addMapAnnotations(stopsArray)
                }
            }
        }
        
        return result
    }
    
    //UPDATE RETURN TYPE
    func getStops( near coordinate: CLLocationCoordinate2D, transportType: TransportType = .Train) -> [TransportStopMapAnnotation]
    {
        let APIURL = Constants.APIEndPoints.StopsNearLocation + "\(coordinate.latitude),\(coordinate.longitude)?route_types=\(transportType)&max_distance=\(Constants.LocationSearch.DefaultDistanceSearch)"
        

        if let task = dataTaskForAPIStops(urlString: APIURL)
        {
            task.resume()
        }
        
        return []
    }
    
    ///Standard URLSession.DataTask completion handler parameter values check. Ensures that no error, reponse is good HTTP and with MIME type of application/json, and that data is not nil
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
}

extension CLLocationCoordinate2D
{
    static func === (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool
    {
        return lhs as AnyObject === rhs as AnyObject
    }
}
