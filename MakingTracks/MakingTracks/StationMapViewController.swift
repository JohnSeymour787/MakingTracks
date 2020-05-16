//
//  ViewController.swift
//  MakingTracks
//
//  Created by user169372 on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import UIKit

class StationMapViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        NetworkController.shared.APIhealthCheck()
        
        
    }

    

}

