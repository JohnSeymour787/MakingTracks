//
//  ScheduledServicesViewController.swift
//  MakingTracks
//
//  Created by John on 5/29/20.
//  Copyright © 2020 John. All rights reserved.
//

import UIKit

class ScheduledServicesViewController: UIViewController, UpdateTableDataDelegate
{
    func downloadComplete()
    {
        DispatchQueue.main.async
        {
            self.tableView.reloadData()
        }
    }
    
    var stopID: Int?
    var stopName: String = ""
    var transportType: TransportType?
    let controller = StopInfoController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopNameLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        tableView.dataSource = controller.self
        
        //Set view title label text
        stopNameLabel.text = stopName + "\(transportType == .Train ? "Station" : "")"
        stopNameLabel.text! += "\(stopID)"
        controller.delegate = self
        controller.beginStopsDataRetrieval(stopID: stopID!)
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
