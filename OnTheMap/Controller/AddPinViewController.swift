//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import MapKit

class AddPinViewController: UIViewController, UITextFieldDelegate {
    let textFieldDelegate = CustomTextFieldDelegate()
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findLocationButton.layer.cornerRadius = 5
        findLocationButton.clipsToBounds = true
        locationTextField.delegate = textFieldDelegate
        urlTextField.delegate = textFieldDelegate
        
    }
    
    @IBAction func findLocationWasTapped(_ sender: Any) {
        
        let location = convertStringToLocation(stringText: locationTextField.text!)
        let url = convertStringtoURL(string: urlTextField.text!)
        
        createPostStudentLocationRequest(url: url!, location: location)
        
//        let destinationVC = AddPinMapViewController.loadViewController()
//        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    func convertStringToLocation(stringText: String) -> CLLocation {
        let geoCoder = CLGeocoder()
        var convertedLocation = CLLocation()
        
        geoCoder.geocodeAddressString(stringText) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location else {
                    self.displayUIAlert(titled: "Couldn't Find Location", withMessage: error?.localizedDescription ?? "")
                    return
            }
            convertedLocation = location
        }
        return convertedLocation
    }
    
    func convertStringtoURL(string: String) -> URL? {
        guard let url = URL(string: string) else {
            print("Couldn't convert string to URL")
            return nil
        }
        if UIApplication.shared.canOpenURL(url) {
            return url
        } else {
            print("URL is not valid")
            return nil
        }
    }
    
    func createPostStudentLocationRequest(url: URL, location: CLLocation) {
        OnTheMapAPIClient.getLoggedinUserData { (success, user, error) in
            guard let user = user else {
                print("Error....")
                return
            }
            
            let request = PostStudentLocationRequest(uniqueKey: user.userId,
                                                     firstName: user.firstName,
                                                     lastName: user.lastName,
                                                     mapString: self.locationTextField.text!,
                                                     mediaURL: url.absoluteString,
                                                     longitude: Float(location.coordinate.longitude),
                                                     latitude: Float(location.coordinate.latitude)
            )
            
            DispatchQueue.main.async {
                let destinvationVC = AddPinMapViewController.loadViewController()
                destinvationVC.request = request
                self.navigationController?.pushViewController(destinvationVC, animated: true)
            }
        }
    }
}



extension AddPinViewController: StoryboardLoadable {
    static var storyboardName: String {
        return "MapAndPin"
    }
}
