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
        OnTheMapAPIClient.getStudentLocations(completion: handleStudentLocationResponse(success:results:error:))
    }
    
    //MARK: API response handler functions
    func handleStudentLocationResponse(success: Bool, results: [StudentLocationDetails]?, error: Error?) {
        if success {
            //unwrap the results array
            if let studentLocationArray = results {
                
                //set the controller's results array to the unwrapped results and add pins on the map
                studentLocationResults = studentLocationArray
                let annotations = createArrayOfAnnotationsForStudentLocations()
                mapView.addAnnotations(annotations)
                
                //Choose a random student as the center student location
                //set map to display random student's location
                let randomNumber = Int.random(in: 0...studentLocationResults.count)
                let longitude = CLLocationDegrees(exactly: studentLocationResults[randomNumber].longitude)
                let latitude = CLLocationDegrees(exactly: studentLocationResults[randomNumber].latitude)
                let region = MKCoordinateRegion.init(
                    center: CLLocationCoordinate2D(
                        latitude: latitude!,
                        longitude: longitude!),
                    latitudinalMeters: 3000000,
                    longitudinalMeters: 3000000)
                
                mapView.region = region
                
                //Once completed end activity indicator
                startActivityIndicator(self.activityIndicator, false)
            }
        } else {
            if let error = error {
                displayUIAlert(titled: "Couldn't get user locations", withMessage: error.localizedDescription)
            } else {
                print("Generic error occured getting user locations")
            }
        }
    }
    
    //MARK: Map/pin  functions
    
    //Take the student location information and create an array of annotations
    func createArrayOfAnnotationsForStudentLocations() -> [MKPointAnnotation] {
        var annnotationArray = [MKPointAnnotation]()
        
        for student in studentLocationResults {
            annnotationArray.append(createPinForStudent(student: student))
        }
        
        return annnotationArray
    }
    
    //Create a point annotation for student location and return it
    func createPinForStudent(student: StudentLocationDetails) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        
        let latitude = CLLocationDegrees(exactly: Float(student.latitude))
        let longitude = CLLocationDegrees(exactly: Float(student.longitude))
        let coord = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        annotation.coordinate = coord
        annotation.title = student.firstName + " " + student.lastName
        annotation.subtitle = student.mediaURL
        
        return annotation
    }
    
}


//MARK: Map view functions
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuse = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuse) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuse)
            pinView!.canShowCallout = true
            pinView!.tintColor = UIColor.red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView!.isHidden = true
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
