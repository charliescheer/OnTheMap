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
    
        
        UserDefaults.standard.set(nil, forKey: "sessionId")
        
    }
    
    @objc func reloadWasTapped() {
        print("reload was tapped")
    }
    
    @objc func addWasTapped() {
        let destination = AddPinViewController.loadViewController()
        self.navigationController?.pushViewController(destination, animated: true)
    }

    
}


extension MapAndPinViewController {
    enum constants {
        static let addSegue = "showAdd"
    }
}
