//
//  UIViewController+Helpers.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

public protocol StoryboardLoadable {
    static var storyboardName: String { get }
    static var controllerID: String { get }
    static var bundle: Bundle { get }
}

public extension StoryboardLoadable where Self: UIViewController {
    
    static var controllerID : String {
        return String(describing: self)
    }
    
    static var bundle: Bundle {
        return Bundle(for: self)
    }
    
    static func loadViewController() -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: controllerID) as? Self else {
            fatalError("[StoryboardLoadable] Cannot instantiate view controller from storyboard.")
        }
        return viewController
    }
}
