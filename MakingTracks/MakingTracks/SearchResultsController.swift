//
//  SearchResultsController.swift
//  MakingTracks
//
//  Created by John on 6/2/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import UIKit

class SearchResultsController: NSObject, NetworkControllerDelegate
{
    var delegate: UpdateTableDataDelegate?
    private var searchResults: [TransportStopMapAnnotation]?
    
    func PTVAPIStatusUpdate(healthCheck: PTVAPIHealthCheckModel)
    {
        
    }
    
    func dataDecodingComplete(_ decodedData: Any)
    {
        if let stopsArray = decodedData as? [TransportStopMapAnnotation]
        {
            searchResults = stopsArray
            delegate?.downloadComplete()
        }
    }
    
    func getSearchResults(searchTerm: String)
    {
        NetworkController.shared.delegate = self
        NetworkController.shared.searchForStops(searchTerm: searchTerm, myLocation: LocationController.shared.lastRecordedCoordinate)
    }
}


extension SearchResultsController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath)// as! DepartureDetailsCell
        
        if searchResults != nil
        {
            //cell.textLabel?.text = [indexPath.row]
            cell.textLabel?.text = searchResults?[indexPath.row].name
            cell.detailTextLabel?.text = searchResults?[indexPath.row].distance.description
            //cell.textLabel?.text =
            //Sets UILabel values for this cell based on the various properties of the current departure
            //cell.setLabels(details: departuresArray![indexPath.row])
        }
        
        return cell
    }
}
