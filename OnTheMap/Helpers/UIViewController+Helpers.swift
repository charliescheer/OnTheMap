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
//        loginButton.isEnabled = !bool
//        signUpButton.isEnabled = !bool
//        usernameTextField.isEnabled = !bool
//        passwordTextField.isEnabled = !bool
    }
}
