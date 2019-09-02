//
//  AddPinMapView.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 9/1/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import MapKit

class AddPinMapViewController: UIViewController, MKMapViewDelegate {
    var request: PostStudentLocationRequest?
    
    
    override func viewDidLoad() {
        if request != nil {
            print("has request")
        }
    }
}

extension AddPinMapViewController: StoryboardLoadable {
    static var storyboardName: String {
        return "MapAndPin"
    }
}
