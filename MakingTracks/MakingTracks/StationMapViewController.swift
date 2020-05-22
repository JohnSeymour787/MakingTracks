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
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateMapRegion(range: 100)
        NetworkController.shared.delegate = self
        NetworkController.shared.APIhealthCheck()
        mapView.delegate = self
        searchTextField.delegate = self
        mapView.register(TransportStopMapView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
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
        print(textField.text!)
        
        //MARK: TODO
        //if text != "" then do a segue to the search screen. then reset .text = ""
        //else, do nothing
        
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
        //Transition here to scheduled services screen
        //Either with segue to another screen
        //Or, make a view that comes up when tapped, see the linkedin vid about mapkit
    }
    
}
