//
//  ViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginWasTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MapAndPin", bundle: Bundle.main)
        
        guard let destination = storyboard.instantiateInitialViewController() else {
            print("failed to instantiate view controller")
            return
        }
        
        present(destination, animated: true, completion: nil)
    }
    
    
}

