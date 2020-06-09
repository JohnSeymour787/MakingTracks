//
//  SearchResultsController.swift
//  MakingTracks
//
//  Created by John on 6/2/20.
//  Copyright © 2020 John. All rights reserved.
//
//  Purpose: Acts as the Controller and table data source for the Search Results screen.
//  Responsible for calling the NetworkController to get search results from the API.

import Foundation
import UIKit

class SearchResultsController: NSObject, NetworkControllerDelegate
{
    //MARK: Properties
    
    private var searchResults: [TransportStop]?
    var delegate: UpdateTableDataDelegate?
    
    //MARK: Methods
    
    func dataDecodingComplete(_ decodedData: Any)
    {
        //If no search results then don't update the array or call the .downloadComplete delegate method
        if let stopsArray = decodedData as? [TransportStop],
            stopsArray.count != 0
        {
            searchResults = stopsArray
            
            //If the first (and thus all elements) have a distance value of 0, then location is turned off so the API couldn't get distance data.
            if searchResults?.first?.distance == 0
            {
                //So, sort by transport type instead, as the search will be for the entire state
                searchResults?.sort{$0.routeType < $1.routeType}
            }
            else
            {
                //Otherwise, a distance search is more appropriate
                searchResults?.sort{$0.distance < $1.distance}
            }
            
            delegate?.downloadComplete()
        }
    }
    
    func getSearchResults(searchTerm: String)
    {
        NetworkController.shared.delegate = self
        NetworkController.shared.searchForStops(searchTerm: searchTerm, myLocation: LocationController.shared.lastRecordedCoordinate)
    }
    
    func currentResult(index: Int) -> TransportStop?
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

//MARK: DataSource Extension
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
