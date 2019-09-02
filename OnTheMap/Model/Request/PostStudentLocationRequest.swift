//
//  PostStudentLocationRequest.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 9/1/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct PostStudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let longitude: Float
    let latitude: Float
}
