//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class MapViewController: MapAndPinViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Map View")
    }
    
    
    @IBAction func tempButtonWasTapped(_ sender: Any) {
        OnTheMapAPIClient.getLoggedInUserData(url: OnTheMapAPIClient.Endpoints.getUserData.url, userId: OnTheMapAPIClient.Auth.key)
    }
}
