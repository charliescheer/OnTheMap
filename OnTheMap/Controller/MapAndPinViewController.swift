//
//  MapAndPinViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import MapKit

class MapAndPinViewController: UIViewController {
    var studentLocationResults: [StudentLocationResults] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutWasTapped))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWasTapped)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.reloadWasTapped)),
        ]
        

        
    }
    
    @objc func logoutWasTapped() {
        OnTheMapAPIClient.Logout { (success, error) in
            if success {
                print("Success")
                DispatchQueue.main.async {
                    let destinationVC = LoginViewController.loadViewController()
                    self.present(destinationVC, animated: true, completion: nil)
                }
                UserDefaults.standard.set(false, forKey: "hasSetLocation")
                UserDefaults.standard.removeObject(forKey: "sessionId")
            } else {
                print(error?.localizedDescription ?? "Generic Error while logging out")
            }
        }
        
        
        
    }
    
    @objc func reloadWasTapped() {
            handleReloadTapped(self)
        }
    
    func handleReloadTapped(_ viewController: UIViewController) {
        if let mapController = viewController as? MapViewController {
           mapController.handleStudentLocationResponse()
        } else if let PinController = viewController as? PinListViewController {
            PinController.handleStudentLocationsRespone()
        }
    }
    
    
    @objc func addWasTapped() {
        performSegue(withIdentifier: constants.addSegue, sender: self)
    }
}


extension MapAndPinViewController {
    enum constants {
        static let addSegue = "showAdd"
    }
}
