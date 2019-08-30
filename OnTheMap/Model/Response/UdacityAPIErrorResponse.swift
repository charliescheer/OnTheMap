//
//  UdacityAPIErrorResponse.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct UdacityAPIErrorResponse: Codable {
    let status: Int
    let error: String
}

extension UdacityAPIErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
