//
//  OnTheMapAPIClient.swift
//  OnTheMap
//
//  Created by Charlie Scheer on 8/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit


class OnTheMapAPIClient {
    struct Auth: Codable {
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let baseURL =  "https://onthemap-api.udacity.com/v1/"
        
        case login
        case signup
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.baseURL + "session"
            case .signup: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let sessionRequest = UdacitySessionRequest(username: username, password: password)
        
        makePostRequest(url: Endpoints.login.url, responseType: UdacityAPILoginResponse.self, headers: ["Accept", "Content-Type"], body: sessionRequest) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.sessionId
                print(Auth.sessionId)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                
                let encoder = PropertyListEncoder()
                do {
                    let data = try encoder.encode(response)
                    UserDefaults.standard.set(data, forKey: "sessionId")
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
    }
    
    
    class func makePostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, headers: [String], body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void ) {
        
        //Define the URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        for field in headers {
            request.addValue("application/json", forHTTPHeaderField: field)
            print(field)
        }
        
        //Encode the Request to JSON and add it to the request body
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(body) else {
            return
        }
        request.httpBody = data
        
        
        //Begin URL Session with created Request
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //Check to make sure the data returned is not nil and is not empty
            guard let data = data else {
                print("data was nil")
                return
            }
            guard data.count != 0 else {
                print("The data received from the server was empty")
                return
            }
            
            //Remove the first 5 characters from data per Udacity security spac
            //Decode data and return the resonse to the completion handler
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(decodedData, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityAPIErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    print(error)
                }
            }
        }
        session.resume()
    }
    
    class func authSessionIdIsSavedToUserDefaults() -> Bool {
        guard (UserDefaults.standard.data(forKey: "sessionId") != nil) else {
            print("No Saved Data")
            return false
        }
        
        return true
    }
    
    class func setSavedAuthSessionId() {
        guard let data = UserDefaults.standard.data(forKey: "sessionId") else {
            print("No Saved Data")
            return
        }
        
        print("decoder created")
        let decoder = PropertyListDecoder()
        do {
            print("decoder running")
            let decodedResponse = try decoder.decode(UdacityAPILoginResponse.self, from: data)
            print("decoder finished")
            Auth.sessionId = decodedResponse.session.sessionId
            print(Auth.sessionId)
        } catch {
            print(error.localizedDescription)
        }
    }
}

