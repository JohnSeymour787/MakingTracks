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
    static let shared = NetworkController()
    
    private init()
    {
        
    }
    
    //UPDATE RETURN TYPE
    func getNearbyStops(near coordinate: CoreLocation.CLLocationCoordinate2D, transportType: TransportType = .Train) -> [Any]
    {
        
        return []
    }
}
