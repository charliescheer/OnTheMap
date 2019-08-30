//
//  ViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let loginTextFieldDelegate = LoginTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = "scheer.charlie@gmail.com"
        passwordTextField.text = "raa8c4TEsUQRK2GvD(FnTEUD7"
        usernameTextField.delegate = loginTextFieldDelegate
        passwordTextField.delegate = loginTextFieldDelegate
    }

    @IBAction func loginWasTapped(_ sender: Any) {
        OnTheMapAPIClient.login(username: usernameTextField.text!, password: passwordTextField.text!) { (success, error) in
            if success {
                print(success)
                self.transitionToMapAndPinStoryBoard()
            
            } else {
                print(error!.localizedDescription)
                self.passwordTextField.text = ""
            }
        }
        
    }
    
    @IBAction func signUpWasTapped(_ sender: Any) {
        UIApplication.shared.open(OnTheMapAPIClient.Endpoints.signup.url)
        
    }
    
    func transitionToMapAndPinStoryBoard() {
        let storyboard = UIStoryboard(name: "MapAndPin", bundle: Bundle.main)
        
        guard let destination = storyboard.instantiateInitialViewController() else {
            print("failed to instantiate view controller")
            return
        }
        
        self.present(destination, animated: true, completion: nil)

    }
}

