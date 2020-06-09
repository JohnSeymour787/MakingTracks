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
    }
    //MARK: Outlets
    
    @IBOutlet weak var stopTypeImage: UIImageView!
    @IBOutlet weak var stopDistanceLabel: UILabel!
    @IBOutlet weak var stopSuburbLabel: UILabel!
    @IBOutlet weak var stopNameLabel: UILabel!

    //MARK: Private Methods
    //Changes the cell image and stop name label color depending on the transport type for this stop
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
    
    //MARK: Public Methods
    ///Sets cell labels and image for a given TransportStop
    func configureCell(for result: TransportStop)
    {
        stopNameLabel.text = result.name
        stopSuburbLabel.text = result.suburb
        
        //Only show the distance label if valid distance data was returned (ie, non-zero)
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
}
