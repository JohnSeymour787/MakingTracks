//
//  LocationControllerDelegate.swift
//  MakingTracks
//
//  Created by user169372 on 5/28/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import CoreLocation
protocol LocationControllerDelegate
{
    func locationUpdated(coordinates: CLLocationCoordinate2D)
}
