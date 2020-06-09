//
//  ViewController.swift
//  MakingTracks
//
//  Created by John on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import UIKit
import MapKit

class StationMapViewController: UIViewController, NetworkControllerDelegate
{
    //MARK: Outlets
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Public Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NetworkController.shared.delegate = self
        mapView.delegate = self
        searchTextField.delegate = self
        
        //Registering the MKAnnotationView class to be the default annotation view used
        mapView.register(TransportStopMapView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //Set the initial camera position of the map, but if location tracking occurs later, then will track the user
        mapView.camera = Constants.MapViewConstants.DefaultCamera
        mapView.setUserTrackingMode(.follow, animated: true)
        
        //Getting all Metro Trains stops, will call addMapAnnotations() delegate method of this class when done
        NetworkController.shared.getAllStops()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        LocationController.shared.prepareLocationServices()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        LocationController.shared.stopLocationServices()
    }
    
    //Update the mapView's annotations with this decoded data, if it is an array of MKAnnotations.
    func dataDecodingComplete(_ decodedData: Any)
    {
        guard let annotations = decodedData as? [MKAnnotation] else
        {
            return
        }
        
        DispatchQueue.main.async
        {
            self.mapView.addAnnotations(annotations)
        }
    }
}

//MARK: Text Field Delegate
extension StationMapViewController: UITextFieldDelegate
{
    //If touches occur off the keyboard, then close it and reset the search bar text
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        searchTextField.resignFirstResponder()
        searchTextField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        if (searchTextField.text != "")
        {
            performSegue(withIdentifier: "searchScreenSegue", sender: nil)
            searchTextField.text = ""
        }
        
        //Text field doesn't need to process the pressing of the button
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let viewController = segue.destination as? SearchScreenViewController
        {
            viewController.searchTerm = searchTextField.text
        }
    }
}

//MARK: Map View Delegate
extension StationMapViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Use the main view controller to instantiate the ScheduledServices scene from it
        let viewController = storyboard.instantiateViewController(identifier: "ScheduledServicesScreen") as! ScheduledServicesViewController
        
        //If this is a transport annotation that had its callout pressed
        if let stopAnnotation = view.annotation as? TransportStop
        {
            //Set the viewController's properties and present it in full-screen view
            viewController.stopID = stopAnnotation.stopID
            viewController.transportType = stopAnnotation.routeType
            viewController.stopName = stopAnnotation.name
            
            present(viewController, animated: true, completion: nil)
        }
    }
}
