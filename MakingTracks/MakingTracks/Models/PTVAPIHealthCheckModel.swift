//
//  PTVAPIHealthCheckModel.swift
//  MakingTracks
//
//  Created by John on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation

struct PTVAPIHealthCheckModel: Decodable
{
    let securityTokenOK: Bool
    let clientClockOK: Bool
    let memcacheOK: Bool
    let databaseOK: Bool
    let yarraOK: Bool?
}
