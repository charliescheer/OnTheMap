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
    var annotations = [MKPointAnnotation]()
    
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
                    
                    self.mapView.addAnnotations(self.annotations)
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
        annotation.subtitle = student.mediaURL
        
        annotations.append(annotation)
    }

}


extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuse = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuse) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuse)
            pinView!.canShowCallout = true
            pinView!.tintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("pin was tapped")
        if control == view.rightCalloutAccessoryView {
            guard let annotation = view.annotation else {
                return
            }
            guard let url = URL(string: annotation.subtitle!!) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                displayUIAlert(titled: "URL Not Valid", withMessage: "Can not open URL for selected student")
            }
        }
    }
}
