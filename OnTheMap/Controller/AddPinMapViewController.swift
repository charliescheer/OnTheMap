//
//  AddPinMapView.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 9/1/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import MapKit

class AddPinMapViewController: UIViewController{
    var request: PostStudentLocationRequest?
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func setLocationWasTapped(_ sender: Any) {
        if let request = request {
            OnTheMapAPIClient.postLoggedInUserLocation(body: request) { (success, error) in
                if success {
                    print("success")
                } else {
                    print("fail")
                }
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        guard let request = request else {
            return
        }
        
        //TO DO handle the force unwrapping
        let longitude = CLLocationDegrees(exactly: request.longitude)
        let latitude = CLLocationDegrees(exactly: request.latitude)
        let region = MKCoordinateRegion.init(
            center: CLLocationCoordinate2D(
                latitude: latitude!,
                longitude: longitude!),
            latitudinalMeters: 5000,
            longitudinalMeters: 5000)
        
        mapView.region = region
        
        mapView.addAnnotation(createPinForPostingFromRequest(request))
        
        mapView.reloadInputViews()
    }
    
    func createPinForPostingFromRequest(_ request: PostStudentLocationRequest) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        
        let latitude = CLLocationDegrees(exactly: request.latitude)
        let longitude = CLLocationDegrees(exactly: request.longitude)
        let coord = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        print(coord)
        
        annotation.coordinate = coord
        annotation.title = "\(request.firstName) \(request.lastName)"
        annotation.subtitle = request.mediaURL
        print(annotation)
        return annotation
    }
}

extension AddPinMapViewController: MKMapViewDelegate {
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
}

extension AddPinMapViewController: StoryboardLoadable {
    static var storyboardName: String {
        return "MapAndPin"
    }
}
