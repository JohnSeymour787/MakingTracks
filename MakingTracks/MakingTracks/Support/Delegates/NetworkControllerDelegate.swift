//
//  NetworkControllerDelegate.swift
//  MakingTracks
//
//  Created by John on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import MapKit

protocol NetworkControllerDelegate: class
{
    func dataDecodingComplete(_ decodedData: Any)
}
