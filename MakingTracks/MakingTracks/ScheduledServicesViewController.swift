//
//  ScheduledServicesViewController.swift
//  MakingTracks
//
//  Created by John on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import UIKit

class ScheduledServicesViewController: UIViewController
{
    var stopID: Int?
    var stopName: String = ""
    var transportType: TransportType?
    
    @IBOutlet weak var stopNameLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Set view title label text
        stopNameLabel.text = stopName + "\(transportType == .Train ? "Station" : "")"
        // Do any additional setup after loading the view.
    }

    
    @IBAction func backToMapButton()
    {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
