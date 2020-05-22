//
//  TransportStopMapAnnotationMarkerView.swift
//  MakingTracks
//
//  Created by user169372 on 5/22/20.
//  Copyright © 2020 John. All rights reserved.
//

import Foundation
import MapKit

class TransportStopMapView: MKAnnotationView
{
    override var annotation: MKAnnotation?
    {
        willSet
        {
            //New value is passed as part of the willSet
            guard let transportStopAnnotation = newValue as? TransportStopMapAnnotation else
            {
                return
            }

            canShowCallout = true
            
            //Creating a custom UILabel for the subtitle to be the callout's detail view
            let subtitle = UILabel()
            subtitle.numberOfLines = 0
            subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(12)
            subtitle.text = "Suburb: \(transportStopAnnotation.suburb)"
            detailCalloutAccessoryView = subtitle
            
            //Timetable button with custom image as the callout's right view
            let timetableButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
            timetableButton.setBackgroundImage(UIImage(named: "TimetableIcon"), for: .normal)
            rightCalloutAccessoryView = timetableButton
            image = UIImage(named: "MetroStationIcon")

        }
    }
}
