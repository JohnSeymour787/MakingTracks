//
//  PTVAPIHealthCheckModel.swift
//  MakingTracks
//
//  Created by user169372 on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation

struct PTVAPIHealthCheckModel : Codable
{
    let securityTokenOK: Bool
    let clientClockOK: Bool
    let memcacheOK: Bool
    let databaseOK: Bool
    let yarraOK: Bool?
}
