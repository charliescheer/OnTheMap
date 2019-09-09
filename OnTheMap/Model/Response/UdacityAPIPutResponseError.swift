//
//  UdacityAPIPutResponseError.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 9/9/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct UdacityAPIPutErrorResponse: Codable {
    let code: Int
    let error: String
}

extension UdacityAPIPutErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
