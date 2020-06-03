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
        
        if let operatingHours = details.operatingHours,
           operatingHours != "N"
        {
            operatingHoursLabel.text = "Operating hours: \(operatingHours)"
            operatingHoursLabel.isHidden = false
            operatingHoursLabel.removeAllConstraints()
            operatingHoursLabel.frame.size.height = 0

        }
        //MARK: TODO
        //-Fix issues with using !, probs mainly just the lost property and phone number can be nil and not and empty string, then hide the labels
        if let phone = details.phoneNumber,
           phone != ""
        {
            phoneNumberLabel.text = "Phone Number: \(phone)"
            phoneNumberLabel.isHidden = false
            
        }
        else
        {
            phoneNumberLabel.frame.size.height = 0
            //phoneNumberLabel.constraints
        }
        
        //let newLabel = UILabel(frame: CGRect(x: 20, y: 115, width: 374, height: 21))
        
        //let topConstraint = NSLayoutConstraint(item: newLabel, attribute: .top, relatedBy: .equal, toItem: nil, attribute: .bottom, multiplier: <#T##CGFloat#>, constant: <#T##CGFloat#>)
        
        //newLabel.addConstraint(NSLayoutConstraint(item: <#T##Any#>, attribute:.top, relatedBy: .equal, toItem: <#T##Any?#>, attribute: ., multiplier: 1, constant: <#T##CGFloat#>))
        
        //operatingHoursLabel.is
        
        if let lostProperty = details.lostPropertyNumber
        {
            lostPropertyLabel.text = "Lost Property Number: \(lostProperty)"
            lostPropertyLabel.isHidden = false
            phoneNumberLabel.removeAllConstraints()
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

private extension UIView
{
    func removeAllConstraints()
    {
        removeConstraints(self.constraints)
    }
}
