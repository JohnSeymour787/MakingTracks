//
//  StopDetailsViewController.swift
//  MakingTracks
//
//  Created by John on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import UIKit

class StopDetailsViewController: UIViewController, UpdateTableDataDelegate
{
    //MARK: Properties
    
    var controller: StopInfoController!
    
    //MARK: Outlets
    
    @IBOutlet weak var toiletLabel: UILabel!
    @IBOutlet weak var elevatorLabel: UILabel!
    @IBOutlet weak var stairsLabel: UILabel!
    @IBOutlet weak var operatingHoursLabel: UILabel!
    @IBOutlet weak var stationDescriptionLabel: UILabel!
    @IBOutlet weak var mykiZoneLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var lostPropertyLabel: UILabel!
    @IBOutlet weak var mykiMachineLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var vlineTicketsLabel: UILabel!
    @IBOutlet weak var titleViewBar: UIView!
    
    //MARK: Methods
    
    //Sets the label texts of this view with the details from its controller's 'stopDetails' property.
    private func updateLabels()
    {
        guard let details = controller.stopDetails else
        {
            return
        }
        
        stationNameLabel.text = details.stopName + "Station"
        stationDescriptionLabel.text = details.stationDescription
    
        operatingHoursLabel.text = "Operating hours: \(details.operatingHours != "N" ? details.operatingHours! : "Not defined." )"

        phoneNumberLabel.text = "Phone Number: \(details.phoneNumber != "" ? details.phoneNumber! : "Not available")"

        lostPropertyLabel.text = "Lost Property Number: \(details.lostPropertyNumber != "" ? details.lostPropertyNumber! : "Not available.")"
        
        mykiZoneLabel.text = "Myki: \(details.mykiZone != "" ? details.mykiZone! : "No information.")"
        
        mykiMachineLabel.text = "Myki Machine: \(details.mykiMachine ? "Yes" : "No")"
        vlineTicketsLabel.text = "VLine Tickets: \(details.vlineTickets ? "Yes" : "No")"
        stairsLabel.text = "Stairs to platform: \(details.stairs ? "Yes" : "No")"
        elevatorLabel.text = "Elevator access to platform: \(details.elevatorAvailable ? "Yes" : "No")"
        toiletLabel.text = "Station toilet: \(details.toilet ? "Yes" : "No")"
    }
    
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
    
    func downloadComplete()
    {
        DispatchQueue.main.async
        {
            self.updateLabels()
        }
    }
}
