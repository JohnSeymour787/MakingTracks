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
    //When the download is complete, hide the activity indicator, unhide the tableView, and reload the data
    func downloadComplete()
    {
        DispatchQueue.main.async
        {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    var stopID: Int?
    var stopName: String = ""
    var transportType: TransportType?
    let controller = StopInfoController()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopNameLabel: UILabel!
    
    @IBOutlet weak var stationDetailsButton: UIButton!
    @IBAction func stationDetailsButtonPressed()
    {
        performSegue(withIdentifier: "stationDetailsSegue", sender: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Stop details are only available for .Train TransportTypes (as per API data)
        stationDetailsButton.isHidden = transportType != .Train
        
        activityIndicator.startAnimating()
        
        tableView.dataSource = controller.self
        
        //Set view title label text
        stopNameLabel.text = stopName + "\(transportType == .Train ? "Station" : "")"
        
        controller.delegate = self
        
        //Guaranteed to have a stopID when loads
        controller.beginStopDataRetrieval(stopID: stopID!)
    }

    
    @IBAction func backToMapButton()
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let viewController = segue.destination as? StopDetailsViewController
        {
            viewController.controller = self.controller
        }
    }
    

}
