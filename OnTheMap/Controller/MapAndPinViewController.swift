//
//  MapAndPinViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class MapAndPinViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutWasTapped))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWasTapped)),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadWasTapped))
        ]
    }
    
    
    @objc func logoutWasTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func reloadWasTapped() {
        print("reload was tapped")
    }
    
    @objc func addWasTapped() {
        print("add was tapped")
    }

}
