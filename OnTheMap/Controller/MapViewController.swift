//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: MapAndPinViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleStudentLocationResponse()
        print("Map View")
        
        
    }
    
    func handleStudentLocationResponse() {
        startActivityIndicator(activityIndicator, true)
        
        
        OnTheMapAPIClient.getStudentLocations { (success, results, error) in
            if success {
                if let studentLocationArray = results {
                    self.studentLocationResults = studentLocationArray
                    self.addPinsFromStudentArrayToMap()
                    self.startActivityIndicator(self.activityIndicator, false)
                }
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    func addPinsFromStudentArrayToMap() {
        for student in studentLocationResults {
            createPinForStudent(student: student)
        }
    }
    
    func createPinForStudent(student: StudentLocationResults) {
        let annotation = MKPointAnnotation()
        let latitude = CLLocationDegrees(exactly: Float(student.latitude))
        let longitude = CLLocationDegrees(exactly: Float(student.longitude))
        let coord = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        annotation.coordinate = coord
        annotation.title = student.firstName + " " + student.lastName
        
        mapView.addAnnotation(annotation)
    }

}
