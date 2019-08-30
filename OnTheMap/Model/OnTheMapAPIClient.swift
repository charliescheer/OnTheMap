//
//  OnTheMapAPIClient.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation

struct Auth {
    
}

struct OnTheMapAPIClient {
    enum Endpoints {
        static let baseURL =  "https://onthemap-api.udacity.com/v1/"
        
        case login
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.baseURL + "session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
}
