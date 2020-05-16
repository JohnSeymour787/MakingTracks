//
//  NetworkController.swift
//  MakingTracks
//
//  Created by user169372 on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import CoreLocation

class NetworkController
{
    private static let healthCheckEndPoint = "https://timetableapi.ptv.vic.gov.au/v2/healthcheck"
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
    
    public func APIhealthCheck() -> Bool
    {
        guard let url: URL = PTVAPISupportClass.generateURL(withDevIDAndKey: NetworkController.healthCheckEndPoint) else
        {
            return false
        }

        let task = session.dataTask(with: url) { data, response, error in
            if error != nil
            {
                print(error.debugDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else
            {
                return
            }
            
            if let mimeType = httpResponse.mimeType, mimeType == "application/json"
            {
                let decoder = JSONDecoder()
                if let APIHealth = try? decoder.decode(PTVAPIHealthCheckModel.self, from: data!)
                {
                    self.delegate?.PTVAPIStatusUpdate(healthCheck: APIHealth)
                    print(APIHealth.securityTokenOK)
                }
            }
                
        }
        
        task.resume()
        
        return true
    }
    
    //UPDATE RETURN TYPE
    func getNearbyStops(near coordinate: CoreLocation.CLLocationCoordinate2D, transportType: TransportType = .Train) -> [Any]
    {
        
        return []
    }
}
