//
//  SearchResultsCell.swift
//  MakingTracks
//
//  Created by user169372 on 6/4/20.
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
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(for result: TransportStopMapAnnotation)
    {
        stopNameLabel.text = result.name
        stopSuburbLabel.text = result.suburb
        
        if result.distance != 0
        {
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 2

            stopDistanceLabel.text = formatter.string(for: result.distance)
            stopDistanceLabel.isHidden = false
        }
        transportTypeSettings(transportType: result.routeType)
    }
    
    private func transportTypeSettings(transportType: TransportType)
    {
        switch transportType
        {
        case .Train:
            layer.backgroundColor = Constants.UIConstants.ColorConstants.MetroBlue.cgColor
        case .Tram:
            layer.backgroundColor = Constants.UIConstants.ColorConstants.TramGreen.cgColor
        case .Bus:
            layer.backgroundColor = Constants.UIConstants.ColorConstants.BusOrange.cgColor
        case .VLineTrainAndBus:
            layer.backgroundColor = Constants.UIConstants.ColorConstants.VLinePurple.cgColor
        case .NightBus:
            layer.backgroundColor = Constants.UIConstants.ColorConstants.NightBusBlue.cgColor
        }
    }
}
