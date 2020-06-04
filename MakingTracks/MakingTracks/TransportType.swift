//
//  TransportType.swift
//  MakingTracks
//
//  Created by John on 5/15/20.
//
//  Purpose: Enumeration to represent the transport types provided by the PTV API and their
//           corresponding raw values.

import Foundation

enum TransportType: Int
{
    case Train = 0
    case Tram = 1
    case Bus = 2
    case VLineTrainAndBus = 3
    case NightBus = 4
}
