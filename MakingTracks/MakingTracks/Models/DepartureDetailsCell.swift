//
//  DepartureDetailsCell.swift
//  MakingTracks
//
//  Created by user169372 on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import UIKit

class DepartureDetailsCell: UITableViewCell
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var platformNumberLabel: UILabel!
    
    @IBOutlet weak var directionLabel: UILabel!
    
    @IBOutlet weak var remainingDepartureTimeLabel: UILabel!
    
    @IBOutlet weak var atPlatformLabel: UILabel!
    
    @IBOutlet weak var departureTime: UILabel!
    
    func setLabels(details: DepartureDetails)
    {
        platformNumberLabel.text = "Platform: \(details.platformNumber)"
        atPlatformLabel.text = "At platform: \(details.atPlatform ? "Yes" : "No")"
        remainingDepartureTimeLabel.text = "\(details.calculatedRemainingTime) minute\(details.calculatedRemainingTime != 1 ? "s" : "")"
        directionLabel.text = details.directionString
        departureTime.text = details.departureTimeString
    }
}
