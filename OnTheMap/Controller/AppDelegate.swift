//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Check and see if there is saved user information in User Defaults
        //If there is load that information into the API client Auth struct and bypass the login view
        //If not load the login view
        if OnTheMapAPIClient.authSessionIdIsSavedToUserDefaults() {
            OnTheMapAPIClient.setSavedAuthSessionIdandUserID()
            
            let storyboard = UIStoryboard(name: "MapAndPin", bundle: Bundle.main)
            let initialVC = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = initialVC
            self.window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
            let initialVC = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = initialVC
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }


}

