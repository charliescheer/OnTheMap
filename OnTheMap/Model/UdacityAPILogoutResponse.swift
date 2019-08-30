//
//  UdacityAPILogoutRequest.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/30/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct UdacityAPILogoutResponse: Decodable {

    let session: Session
    
}

struct session: Decodable {
    let expiration: String
    let id: String
}
