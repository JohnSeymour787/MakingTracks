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
    

    @IBOutlet weak var mykiZoneLabel: UILabel!
    @IBOutlet weak var stationNameLabel: UILabel!
    var controller: StopInfoController!
    
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
        mykiZoneLabel.text = "Myki Zone: " + details.mykiZone!
    }

}
