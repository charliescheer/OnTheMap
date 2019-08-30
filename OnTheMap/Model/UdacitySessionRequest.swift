//
//  UdacitySessionRequest.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct UdacitySessionRequest: Codable {
    let udacity: [String: String]
    
    init (username: String, password: String) {
        self.udacity = ["username" : username, "password" : password]
    }
}
