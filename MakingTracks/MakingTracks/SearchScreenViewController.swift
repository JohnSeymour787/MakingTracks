//
//  SearchScreenViewController.swift
//  MakingTracks
//
//  Created by John on 6/2/20.
//  Copyright © 2020 John. All rights reserved.
//

import UIKit

class SearchScreenViewController: UIViewController, UpdateTableDataDelegate
{
    
    //New data is available from the dataView's data source
    func downloadComplete()
    {
        DispatchQueue.main.async
        {
            self.dataView.reloadData()
        }
    }
    
    var searchTerm: String!

    let controller = SearchResultsController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        dataView.delegate = self
        controller.delegate = self
        dataView.dataSource = controller
        
        searchTermLabel.text = "Results for: \"\(searchTerm!)\""
        
        //Make the controller initiate an API call to get the search results and provide the data for the dataView
        controller.getSearchResults(searchTerm: searchTerm)
    }
    
    @IBAction func backButtonPressed()
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchTermLabel: UILabel!
    
    @IBOutlet weak var dataView: UITableView!
    
}


//Uses section headers for spacing between cell rows (sections)
extension SearchScreenViewController: UITableViewDelegate
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
    
    //If a Metro Trains station cell is tapped, open the ScheduledServicesScreen for it
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cellResultSelected = controller.currentResult(index: indexPath.section)
        {
            if cellResultSelected.routeType == .Train
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                //Use the main view controller to instantiate the ScheduledServices scene from it
                let viewController = storyboard.instantiateViewController(identifier: "ScheduledServicesScreen") as! ScheduledServicesViewController
                    
                //Set the viewController's properties and present it in full-screen view
                viewController.stopID = cellResultSelected.stopID
                viewController.transportType = cellResultSelected.routeType
                viewController.stopName = cellResultSelected.name
                        
                present(viewController, animated: true, completion: nil)
            }
        }
    }
}
