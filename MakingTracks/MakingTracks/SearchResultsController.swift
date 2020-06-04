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
            searchResults?.sort{$0.distance < $1.distance}
            
            delegate?.downloadComplete()
        }
    }
    
    func getSearchResults(searchTerm: String)
    {
        NetworkController.shared.delegate = self
        NetworkController.shared.searchForStops(searchTerm: searchTerm, myLocation: LocationController.shared.lastRecordedCoordinate)
    }
    
    func currentResult(index: Int) -> TransportStopMapAnnotation?
    {
        guard index >= 0,
              searchResults != nil,
              index < searchResults!.count
        else
        {
            return nil
        }
        
        return searchResults?[index]
    }
}


extension SearchResultsController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultCell", for: indexPath) as! SearchResultCell
        
        if searchResults != nil
        {

            cell.configureCell(for: searchResults![indexPath.section])

        }
        
        return cell
    }
}
