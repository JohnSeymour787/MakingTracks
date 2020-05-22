//
//  ViewController.swift
//  MakingTracks
//
//  Created by user169372 on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import UIKit
import MapKit

class StationMapViewController: UIViewController, NetworkControllerDelegate
{
    func PTVAPIStatusUpdate(healthCheck: PTVAPIHealthCheckModel) {
        
    }
    
    func addMapAnnotations(_ annotations: [MKAnnotation]) {
        DispatchQueue.main.async
        {
            self.mapView.addAnnotations(annotations)
        }
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateMapRegion(range: 100)
        NetworkController.shared.delegate = self
        NetworkController.shared.APIhealthCheck()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = Constants.LocationSearch.MelbourneCDB
        annotation.title = "Center"
        annotation.subtitle = "Subtitle"
        
        mapView.addAnnotation(annotation)
        
        NetworkController.shared.getNearbyStops(near: Constants.LocationSearch.MelbourneCDB)
    }

    func updateMapRegion(range: CLLocationDistance)
    {
        let region = MKCoordinateRegion(center: Constants.LocationSearch.MelbourneCDB, latitudinalMeters: 1000, longitudinalMeters: 1000)
        let camera = MKMapCamera(lookingAtCenter: Constants.LocationSearch.MelbourneCDB, fromDistance: 5000, pitch: 0, heading: 0)
        mapView.camera = camera
        //mapView.region = region
        
        
    }

}

