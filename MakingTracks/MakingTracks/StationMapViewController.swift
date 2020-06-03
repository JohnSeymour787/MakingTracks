//
//  ViewController.swift
//  MakingTracks
//
//  Created by John on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//
/*
    TODO:
    -Implementation for PTVAPIStatusUpdate method
        -Should have a popup if the healthcheck fails (do in main queue)
    -textFieldShouldReturn() delegate method should start a segue to the search screen, passing it the text in the textfield
    -Remove old MapViewDelegate commented function's code
 */

import UIKit
import MapKit

class StationMapViewController: UIViewController, NetworkControllerDelegate
{
    func PTVAPIStatusUpdate(healthCheck: PTVAPIHealthCheckModel)
    {
        
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
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        NetworkController.shared.delegate = self
        mapView.delegate = self
        searchTextField.delegate = self
        
        //Registering the MKAnnotationView class to be the default annotation view used
        mapView.register(TransportStopMapView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.camera = Constants.MapViewConstants.DefaultCamera
        mapView.setUserTrackingMode(.follow, animated: true)
        
        NetworkController.shared.APIhealthCheck()
        
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
}


extension StationMapViewController: UITextFieldDelegate
{
    //If touches occur off the keyboard, then close it and reset the search bar text
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        searchTextField.resignFirstResponder()
        searchTextField.text = ""
    }
    
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let viewController = segue.destination as? SearchScreenViewController
        {
            viewController.searchTerm = searchTextField.text
        }
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
}

extension StationMapViewController: MKMapViewDelegate
{
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        var annotationView = MKAnnotationView()
        
        guard let annotation = annotation as? TransportStopMapAnnotation else
        {
            return nil
        }
        
        //If a pin of this identifier already exists, use it
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView
        {
            annotationView = dequeuedView
        }
        //Otherwise, need to create new annotation
        else
        {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        }
        
        /*/
        var annotationView = MKPinAnnotationView()
        
        guard let annotation = annotation as? TransportStopMapAnnotation else
        {
            return nil
        }
        
        //If a pin of this identifier already exists, use it
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKPinAnnotationView
        {
            annotationView = dequeuedView
        }
        //Otherwise, need to create new annotation
        else
        {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotation.identifier)
        }
 */
        /*annotationView.t
        
        //annotationView.pinTintColor = .blue
        
        //annotationView.image = UIImage
        
        annotationView.canShowCallout = true
        
        let title = UILabel()
        title.numberOfLines = 0
        title.font = UIFont.preferredFont(forTextStyle: .callout)
        //title.text = "Title"
        annotationView.largeContentTitle = "Things"
        annotationView.detailCalloutAccessoryView = title
        //annotationView.tit
        //annotationView.leftCalloutAccessoryView
        //annotationView.rightCalloutAccessoryView
        return annotationView
        
    }
    */
 */

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        //let stopInfoController = StopInfoController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //Use the main view controller to instantiate the ScheduledServices scene from it
        let viewController = storyboard.instantiateViewController(identifier: "ScheduledServicesScreen") as! ScheduledServicesViewController
        
        //If this is a transport annotation that had its callout pressed
        if let stopAnnotation = view.annotation as? TransportStopMapAnnotation
        {
            //Set the viewController's properties and present it in full-screen view
            viewController.stopID = stopAnnotation.stopID
            viewController.transportType = stopAnnotation.routeType
            viewController.stopName = stopAnnotation.name
            
            present(viewController, animated: true, completion: nil)
        }
    }
}
