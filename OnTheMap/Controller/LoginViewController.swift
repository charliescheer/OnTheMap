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
        
        usernameTextField.text = ""
        passwordTextField.text = ""
        usernameTextField.delegate = loginTextFieldDelegate
        passwordTextField.delegate = loginTextFieldDelegate
        signUpButton.layer.cornerRadius = 5
        signUpButton.clipsToBounds = true
    }

    @IBAction func loginWasTapped(_ sender: Any) {
        //Attempt to login the user
        startActivityIndicator(activityIndicator, true)
        OnTheMapAPIClient.login(username: usernameTextField.text!, password: passwordTextField.text!, completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpWasTapped(_ sender: Any) {
        //Open the Signup page for udacity
        UIApplication.shared.open(OnTheMapAPIClient.Endpoints.signup.url)
        
    }
    
    //Prepares for and loads the map storyboard and initial view controller
    func transitionToMapAndPinStoryBoard() {
        let storyboard = UIStoryboard(name: "MapAndPin", bundle: Bundle.main)
        
        guard let destination = storyboard.instantiateInitialViewController() else {
            print("failed to instantiate view controller")
            return
        }
        
        self.present(destination, animated: true, completion: nil)
    }
    
    //Handles the repsonse to the API login attempt
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print("login successful")
            startActivityIndicator(activityIndicator, false)
            usernameTextField.text = ""
            passwordTextField.text = ""
            transitionToMapAndPinStoryBoard()
        } else {
            //Displays an generic error if the login fails and there is no returned error
            guard let error = error else {
                displayUIAlert(titled: "Unknown Error", withMessage: "A generic error occured, please try again")
                return
            }
            
            //Display the error from the login response
            //clear the password field
            displayUIAlert(titled: "Error", withMessage: error.localizedDescription)
            passwordTextField.text = ""
        }
    }
}

extension LoginViewController: StoryboardLoadable {
    static var storyboardName: String {
        return "Login"
    }
}
