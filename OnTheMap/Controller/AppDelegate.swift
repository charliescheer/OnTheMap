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
        
        if OnTheMapAPIClient.authSessionIdIsSavedToUserDefaults() {
            print("found session ID")
            
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

