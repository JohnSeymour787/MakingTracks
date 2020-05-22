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
            guard let transportStopAnnotation = newValue as? TransportStopMapAnnotation else
            {
                return
            }

            canShowCallout = true
            
            
            
            let subtitle = UILabel()
            subtitle.numberOfLines = 0
            subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
            subtitle.text = "Suburb: \(transportStopAnnotation.suburb)"
            detailCalloutAccessoryView = subtitle
            
            let timetableButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
            timetableButton.setBackgroundImage(UIImage(named: "TimetableIcon"), for: .normal)
            rightCalloutAccessoryView = timetableButton
            image = UIImage(named: "MetroStationIcon")

            
        }
    }
}
