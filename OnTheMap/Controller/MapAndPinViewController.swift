//
//  MapAndPinViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import MapKit

//Class serves as the base for the list and map views
//Setups up the navigation, add, and logout for the detail views
class MapAndPinViewController: UIViewController {
    var studentLocationResults: [StudentLocationDetails] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutWasTapped))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWasTapped)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.reloadWasTapped)),
        ]
        

        
    }
    
    @objc func logoutWasTapped() {
        OnTheMapAPIClient.Logout(completion: handleLogoutResponse(success:error:))
    }
    
    @objc func reloadWasTapped() {
            handleReloadTapped(self)
        }
    
    func handleReloadTapped(_ viewController: UIViewController) {
        if let mapController = viewController as? MapViewController {
            OnTheMapAPIClient.getStudentLocations(completion: mapController.handleStudentLocationResponse(success:results:error:))
        } else if let pinController = viewController as? PinListViewController {
            OnTheMapAPIClient.getStudentLocations(completion: pinController.handleStudentLocationResponse(success:results:error:))
        }
    }
    
    
    @objc func addWasTapped() {
        performSegue(withIdentifier: constants.addSegue, sender: self)
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            print("Logout Success")
            self.dismiss(animated: true) {
                let destinationVC = LoginViewController.loadViewController()
                self.present(destinationVC, animated: true, completion: nil)
            }
        } else {
            print(error?.localizedDescription ?? "Generic Error while logging out")
        }
    }
}


extension MapAndPinViewController {
    enum constants {
        static let addSegue = "showAdd"
    }
}
