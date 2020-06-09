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
    //MARK: Properties
    
    private let controller = StopInfoController()
    var stopID: Int!
    var stopName: String!
    var transportType: TransportType!
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    //MARK: Outlets
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stopNameLabel: UILabel!
    @IBOutlet weak var stationDetailsButton: UIButton!
    
    //MARK: Public Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Stop details are only available for .Train TransportTypes (as per API data)
        stationDetailsButton.isHidden = transportType != .Train
        
        activityIndicator.startAnimating()
        
        tableView.dataSource = controller
        tableView.delegate = self
        
        //Set view title label text
        stopNameLabel.text = stopName
        
        //If this is a train station and doesn't already have the name 'station' in it (from the results API call), then add the word to the end
        if transportType == .Train && !stopName.contains("Station")
        {
            stopNameLabel.text? += "Station"
        }
        
        controller.delegate = self
        
        //Guaranteed to have a stopID and transportType when loads
        controller.beginStopDataRetrieval(stopID: stopID, transportType: transportType)
    }
    
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
    
    //In case the delegate was removed by the StopDetails ViewController
    override func viewWillAppear(_ animated: Bool)
    {
        controller.delegate = self
    }

    //MARK: Actions

    @IBAction func stationDetailsButtonPressed()
    {
        performSegue(withIdentifier: "stationDetailsSegue", sender: nil)
    }
    
    @IBAction func backToMapButton()
    {
        dismiss(animated: true, completion: nil)
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

//MARK: Table View Delegate
//Uses section headers for spacing between cell rows (sections)
extension ScheduledServicesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return CGFloat(Constants.UIConstants.TableViewSectionSpacing)
    }
    
    //Header is a transparent UIView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
}
