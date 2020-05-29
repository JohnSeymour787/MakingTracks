//
//  NetworkControllerDelegate.swift
//  MakingTracks
//
//  Created by user169372 on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import MapKit

protocol NetworkControllerDelegate: class
{
    func PTVAPIStatusUpdate(healthCheck: PTVAPIHealthCheckModel)
    func dataDecodingComplete(_ decodedData: [Any])
}
