//
//  StationDetails.swift
//  MakingTracks
//
//  Created by John on 5/30/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation

class StationDetails
{
    let stopID: Int
    let routeType: TransportType
    let stopName: String
    let mykiZone: String?
    let operatingHours: String?
    let phoneNumber: String?
    let lostPropertyNumber: String?
    let mykiMachine: Bool
    let stationDescription: String?
    let stairs: Bool
    let elevatorAvailable: Bool
    let vlineTickets: Bool
    let toilet: Bool
    
    private init(_ stopID: Int, _ routeType: TransportType, _ stopName: String, _ stationDescription: String?, _ operatingHours: String?, _ phoneNumber: String?, _ lostPropertyNumber: String?, _ mykiZone: String?, _ mykiMachine: Bool, _ vlineTickets: Bool, _ stairs: Bool, _ elevator: Bool, _ toilet: Bool)
    {
        self.stopID = stopID
        self.routeType = routeType
        self.stopName = stopName
        self.stationDescription = stationDescription
        self.operatingHours = operatingHours
        self.phoneNumber = phoneNumber
        self.lostPropertyNumber = lostPropertyNumber
        self.mykiZone = mykiZone
        self.mykiMachine = mykiMachine
        self.vlineTickets = vlineTickets
        self.stairs = stairs
        self.elevatorAvailable = elevator
        self.toilet = toilet
    }
    
    
    
    ///Converts a raw JSON Any object to a single class instance containing all details for a station.
    static func decodeToInstance(rawJSON: Any) -> StationDetails?
    {
        //Getting all the inner JSON objects that must exist due to API call parameters
        guard
            let jsonOuterObject = rawJSON as? [String: Any],
            let stop = jsonOuterObject["stop"] as? [String: Any],
            let stopContact = stop["stop_contact"] as? [String: Any],
            let stopTicket = stop["stop_ticket"] as? [String: Any],
            let stopAmenities = stop["stop_amenities"] as? [String: Any],
            let stopAccessibility = stop["stop_accessibility"] as? [String: Any]
        else
        {
            return nil
        }
        
        //Also, the stopID and routeType must exist for future possible API calls for departures
        guard
            let stopID = stop["stop_id"] as? Int,
            let routeTypeRaw = stop["route_type"] as? Int,
            let routeType = TransportType(rawValue: routeTypeRaw)
        else
        {
            return nil
        }

        let stopName = stop["stop_name"] as? String ?? ""
        let stationDescription = stop["station_description"] as? String
        
        let operatingHours = stop["operating_hours"] as? String
        
        let phoneNumber = stopContact["phone"] as? String
        let lostPropertyNumber = stopContact["lost_property"] as? String
        
        let mykiZone = stopTicket["zone"] as? String
        let mykiMachine = stopTicket["ticket_machine"] as? Bool ?? false
        let vlineTickets = stopTicket["vline_reservation"] as? Bool ?? false
        
        let toilet = stopAmenities["toilet"] as? Bool ?? false
        
        let stairs = stopAccessibility["stairs"] as? Bool ?? false
        let elevatorAvailable = stopAccessibility["lift"] as? Bool ?? false

        return StationDetails(stopID, routeType, stopName, stationDescription, operatingHours, phoneNumber, lostPropertyNumber, mykiZone, mykiMachine, vlineTickets, stairs, elevatorAvailable, toilet)
    }
}
