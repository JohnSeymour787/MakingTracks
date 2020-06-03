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

        searchTermLabel.text = searchTerm
        controller.delegate = self
        dataView.dataSource = controller
        controller.getSearchResults(searchTerm: searchTerm)
    }
    
    @IBAction func backButtonPressed()
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchTermLabel: UILabel!
    
    @IBOutlet weak var dataView: UITableView!
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation


}
