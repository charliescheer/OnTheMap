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

class OnTheMapAPIClient {
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
    
    class func login(username: String, password: String, competion: @escaping (Bool, Error?) -> Void) {
        let sessionRequest = UdacitySessionRequest(username: username, password: password)
        
        makePostRequest(url: Endpoints.login.url, requestType: UdacitySessionRequest.self, headers: ["Content-Type", "Accept"], body: sessionRequest) { (response, error) in
            if let response = response {
                competion(true, nil)
            } else {
                competion(false, error)
            }
        }
    }
    
    
    class func makePostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, requestType: ResponseType.Type, headers: [String], body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        for field in headers {
            request.addValue("application/json", forHTTPHeaderField: field)
        }
        
        let encoder = JSONEncoder()
        
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            print(error)
        }
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(UdacitySessionRequest.self, from: data)
                print(decodedData)
            } catch {
                do {
                    let decodedError = try decoder.decode(UdacityAPIResponse.self, from: data)
                    print(decodedError.error)
                } catch {
                    print(error)
                }
            }
            
        }
        session.resume()
    }
}

