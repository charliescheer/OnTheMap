//
//  UdacitySessionRequest.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct UdacitySessionRequest: Codable {
    let username: String
    let password: String
    let udacity: [String: String]
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self.udacity = ["username" : username, "password" : password]
    }
    
    
    
    
}
