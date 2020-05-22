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
            
            
            
            let title = UILabel()
            title.numberOfLines = 0
            title.font = UIFont.preferredFont(forTextStyle: .callout)
            //title.text = "Title"
            largeContentTitle = "Things"
            detailCalloutAccessoryView = title
            title.text? = "my title"
            rightCalloutAccessoryView = UIButton(type: .infoLight
            )
            image = UIImage(named: "MetroStationIcon")
        }
    }
}
