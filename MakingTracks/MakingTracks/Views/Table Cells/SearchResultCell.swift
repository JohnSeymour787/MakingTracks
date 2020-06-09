//
//  SearchResultsCell.swift
//  MakingTracks
//
//  Created by John on 6/4/20.
//  Copyright © 2020 John. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell
{

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var stopTypeImage: UIImageView!
    @IBOutlet weak var stopDistanceLabel: UILabel!
    @IBOutlet weak var stopSuburbLabel: UILabel!
    @IBOutlet weak var stopNameLabel: UILabel!

    func configureCell(for result: TransportStop)
    {
        stopNameLabel.text = result.name
        stopSuburbLabel.text = result.suburb
        
        if result.distance != 0
        {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            
            stopDistanceLabel.text = formatter.string(for: result.distance)
            stopDistanceLabel.text? += " km"
            stopDistanceLabel.isHidden = false
        }
        transportTypeSettings(transportType: result.routeType)
    }
    
    private func transportTypeSettings(transportType: TransportType)
    {
        switch transportType
        {
        case .Train:
            stopTypeImage.image = UIImage(named: "Metro")
            stopNameLabel.textColor = Constants.UIConstants.ColorConstants.MetroBlue
            
        case .Tram:
            stopTypeImage.image = UIImage(named: "YarraTrams")
            stopNameLabel.textColor = Constants.UIConstants.ColorConstants.TramGreen
            
        case .Bus:
            stopTypeImage.image = UIImage(named: "Bus")
            stopNameLabel.textColor = Constants.UIConstants.ColorConstants.BusOrange
            
        case .VLineTrainAndBus:
            stopTypeImage.image = UIImage(named: "VLine")
            stopNameLabel.textColor = Constants.UIConstants.ColorConstants.VLinePurple
            
        case .NightBus:
            stopTypeImage.image = UIImage(named: "NightBus")
            stopNameLabel.textColor = Constants.UIConstants.ColorConstants.NightBusBlue
        }
    }
}
