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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let loginTextFieldDelegate = CustomTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.text = "scheer.charlie@gmail.com"
        passwordTextField.text = "raa8c4TEsUQRK2GvD(FnTEUD7"
        usernameTextField.delegate = loginTextFieldDelegate
        passwordTextField.delegate = loginTextFieldDelegate
        signUpButton.layer.cornerRadius = 5
        signUpButton.clipsToBounds = true
    }

    @IBAction func loginWasTapped(_ sender: Any) {
        startActivityIndicator(activityIndicator, true)
        OnTheMapAPIClient.login(username: usernameTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
        
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
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print(success)
            self.startActivityIndicator(self.activityIndicator, false)
            OnTheMapAPIClient.getLoggedinUserData { (success, user, error) in
                print(success)
                print(user?.firstName)
                print(error?.localizedDescription)
            }
            
            self.transitionToMapAndPinStoryBoard()
        } else {
            guard let error = error else {
                displayUIAlert(titled: "Unknown Error", withMessage: "A generic error occured, please try again")
                return
            }
            
            displayUIAlert(titled: "Error", withMessage: error.localizedDescription)
            self.passwordTextField.text = ""
        }
    }
}

extension LoginViewController: StoryboardLoadable {
    static var storyboardName: String {
        return "Login"
    }
}
