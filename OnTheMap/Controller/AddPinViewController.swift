//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/28/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class AddPinViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

extension AddPinViewController: StoryboardLoadable {
    static var storyboardName: String {
        return "MapAndPin"
    }
}
