//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddPinViewController: UIViewController, UITextFieldDelegate {
    let textFieldDelegate = CustomTextFieldDelegate()
    var setLocation: CLLocation?
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findLocationButton.layer.cornerRadius = 5
        findLocationButton.clipsToBounds = true
        locationTextField.delegate = textFieldDelegate
        urlTextField.delegate = textFieldDelegate
        locationTextField.text = "1 Infinite Loop, CA, USA"
        urlTextField.text = "https://udacity.com/"
    }
    //TO DO Go through the flow of converting the string to location and see if there are too many optionals for the location.
    
    @IBAction func findLocationWasTapped(_ sender: Any) {
        
        convertStringToLocation(stringText: locationTextField.text!) { (location, error) in
            self.setLocation = location
            
            guard self.setLocation != nil else {
                print("no location")
                return
            }
            
            guard let url = self.convertStringtoURL(string: self.urlTextField.text!) else {
                print("no url")
                return
            }
            
            self.createPostStudentLocationRequest(url: url, location: self.setLocation!)
            
        }
    }
    
    @IBAction func cancelWasTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func convertStringToLocation(stringText: String, completion: @escaping (CLLocation?, Error?) -> Void) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(stringText) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location else {
                    self.displayUIAlert(titled: "Couldn't Find Location", withMessage: error?.localizedDescription ?? "")
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    
                    return
            }
            
            DispatchQueue.main.async {
                print(location)
                completion(location, nil)
            }
            
            
        }
    }
    
    
    func handleLocationConversion(location: CLLocation?, error: Error?) {
        guard let location = location else {
            print("couldn't unwrap location")
            print(error)
            return
        }
        
        DispatchQueue.main.async {
            self.setLocation = location
        }
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
                self.displayUIAlert(titled: "Couldn't Post Location", withMessage: error?.localizedDescription ?? "Generic Error")
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
            
            print(request.latitude)
            print(request.longitude)
            
            
            let destinvationVC = AddPinMapViewController.loadViewController()
            destinvationVC.request = request
            self.navigationController?.pushViewController(destinvationVC, animated: true)
            
        }
    }
}


extension AddPinViewController: StoryboardLoadable {
    static var storyboardName: String {
        return "MapAndPin"
    }
}
