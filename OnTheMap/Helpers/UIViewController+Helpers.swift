//
//  UIViewController+Helpers.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 9/1/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

extension UIViewController {
    func startActivityIndicator(_ activityIndicator: UIActivityIndicatorView, _ bool: Bool) {
        if bool {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        self.isEditing = !bool
    }
    
    func displayUIAlert(titled title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Okay", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
