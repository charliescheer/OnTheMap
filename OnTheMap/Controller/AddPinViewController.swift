//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

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
        let destinationVC = AddPinMapViewController.loadViewController()
        navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
}

extension AddPinViewController: StoryboardLoadable {
    static var storyboardName: String {
        return "MapAndPin"
    }
}
