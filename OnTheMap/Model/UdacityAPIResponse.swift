//
//  UdacityAPIResponse.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct UdacityAPIResponse: Decodable {
    let account: Account
    let session: Session
}
    
    struct Account: Decodable {
        let key: String
        let registered: Bool
    }
    
    struct Session: Decodable {
        let expiration: String
        let sessionId: String
        
        enum CodingKeys: String, CodingKey {
            case expiration
            case sessionId = "id"
        }
    }
