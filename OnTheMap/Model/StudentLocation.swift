//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/30/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let results: [StudentLocationResults]
}

struct StudentLocationResults: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
}
