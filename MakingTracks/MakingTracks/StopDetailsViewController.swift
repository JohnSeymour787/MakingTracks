//
//  StopDetailsViewController.swift
//  MakingTracks
//
//  Created by user169372 on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import UIKit

class StopDetailsViewController: UIViewController, UpdateTableDataDelegate
{
    func downloadComplete()
    {
        DispatchQueue.main.async
        {
            self.updateLabels()
        }
    }
    
    @IBOutlet weak var toiletLabel: UILabel!
    @IBOutlet weak var elevatorLabel: UILabel!
    @IBOutlet weak var stairsLabel: UILabel!
    @IBOutlet weak var operatingHoursLabel: UILabel!
    @IBOutlet weak var stationDescriptionLabel: UILabel!
    
    @IBOutlet weak var mykiZoneLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    var controller: StopInfoController!
    
    @IBOutlet weak var lostPropertyLabel: UILabel!
    
    @IBOutlet weak var mykiMachineLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var vlineTicketsLabel: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //If the controller has not yet updated its stopDetails, quickly make this view the delegate so it can update the labels with the received stop details
        if controller.stopDetails == nil
        {
            controller.delegate = self
        }
        else
        {
            updateLabels()
        }
    }
    
    private func updateLabels()
    {
        guard let details = controller.stopDetails else
        {
            return
        }
        
        stationNameLabel.text = details.stopName + "Station"
        stationDescriptionLabel.text = details.stationDescription
        
        if let operatingHours = details.operatingHours
        {
            operatingHoursLabel.text = "Operating hours: \(operatingHours)"
            operatingHoursLabel.isHidden = false
        }
        
        if let phone = details.phoneNumber
        {
            phoneNumberLabel.text = "Phone Number: \(details.phoneNumber!)"
        }
        
        if let lostProperty = details.lostPropertyNumber
        {
            lostPropertyLabel.text = "Lost Property Number: \(details.lostPropertyNumber!)"
        }
        
        if let mykiZone = details.mykiZone
        {
            mykiZoneLabel.text = "Myki: " + details.mykiZone!
        }
        
        mykiMachineLabel.text = "Myki Machine: \(details.mykiMachine ? "Yes" : "No")"
        vlineTicketsLabel.text = "VLine Tickets: \(details.vlineTickets ? "Yes" : "No")"
        stairsLabel.text = "Stairs to platform: \(details.stairs ? "Yes" : "No")"
        elevatorLabel.text = "Elevator access to platform: \(details.elevatorAvailable ? "Yes" : "No")"
        toiletLabel.text = "Station toilet: \(details.toilet ? "Yes" : "No")"
        
    }

}
