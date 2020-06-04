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
    
    var stopID: Int!
    var stopName: String!
    var transportType: TransportType!
    let controller = StopInfoController()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopNameLabel: UILabel!
    
    @IBOutlet weak var stationDetailsButton: UIButton!
    
    @IBAction func stationDetailsButtonPressed()
    {
        performSegue(withIdentifier: "stationDetailsSegue", sender: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Stop details are only available for .Train TransportTypes (as per API data)
        stationDetailsButton.isHidden = transportType != .Train
        
        activityIndicator.startAnimating()
        
        tableView.dataSource = controller
        tableView.delegate = self
        //Set view title label text
        stopNameLabel.text = stopName + "\(transportType == .Train ? "Station" : "")"
        
        controller.delegate = self
        
        //Guaranteed to have a stopID and transportType when loads
        controller.beginStopDataRetrieval(stopID: stopID, transportType: transportType)
    }

    
    @IBAction func backToMapButton()
    {
        dismiss(animated: true, completion: nil)
    }
    
    //In case the delegate was removed by the StopDetails ViewController
    override func viewWillAppear(_ animated: Bool)
    {
        controller.delegate = self
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let viewController = segue.destination as? StopDetailsViewController
        {
            viewController.controller = self.controller
        }
    }
    

}

extension ScheduledServicesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return CGFloat(Constants.UIConstants.TableViewSectionSpacing)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
}
