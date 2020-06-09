//
//  DepartureDetailsCell.swift
//  MakingTracks
//
//  Created by John on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import UIKit

class DepartureDetailsCell: UITableViewCell
{
    //MARK: Outlets
    
    @IBOutlet weak var platformNumberLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var remainingDepartureTimeLabel: UILabel!
    @IBOutlet weak var atPlatformLabel: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    
    //MARK: Public Methods
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    ///Sets all label texts with the details of a given departure
    func setLabels(details: DepartureDetails)
    {
        platformNumberLabel.text = "Platform: \(details.platformNumber)"
        
        atPlatformLabel.text = "At platform: \(details.atPlatform ? "Yes" : "No")"
        
        remainingDepartureTimeLabel.text = "\(details.calculatedRemainingTime) min\(details.calculatedRemainingTime != 1 ? "s" : "")"
        
        directionLabel.text = details.directionString
        
        departureTime.text = details.departureTimeString
    }
}
