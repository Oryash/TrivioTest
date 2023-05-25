//
//  CustomPinView.swift
//  TrivioTest
//
//  Created by Anvar Bagautdinov on 25.05.2023.
//

import UIKit
import MapKit

class CustomPinView: MKPinAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        // Customize the pin's appearance
        //            pinTintColor = UIColor.red
        //            canShowCallout = true
        image = UIImage(named: "Pin")

        // Add additional views or customize as needed
        let button = UIButton(type: .detailDisclosure)
        rightCalloutAccessoryView = button
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

