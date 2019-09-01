//
//  UdacityAPIResponse.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct UdacityAPILoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let key: String
    let registered: Bool
}

struct Session: Codable {
    let expiration: String
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case expiration
        case sessionId = "id"
    }
}
