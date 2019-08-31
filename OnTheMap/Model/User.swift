//
//  User.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/30/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct User: Codable {
    let lastName: String
    let socialAccounts: [String]
    let mailingAddress: String?
    let facebookId: String?
    let firstName: String
    let email: Email
    let websiteURL: String
    let nickname: String
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case socialAccounts
        case mailingAddress
        case facebookId
        case firstName = "first_name"
        case email
        case websiteURL = "website_url"
        case nickname
        case userId = "key"
    }
}

struct Email: Codable {
    let verifcationCodeSent: Bool
    let verified: Bool
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case verifcationCodeSent = "_verification_code_sent"
        case verified = "_verified"
        case address
    }
}
