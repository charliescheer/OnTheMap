//
//  LoginTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/30/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class CustomTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
