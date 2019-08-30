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
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let sessionRequest = UdacitySessionRequest(username: username, password: password)
        
        makePostRequest(url: Endpoints.login.url, responseType: UdacityAPILoginResponse.self, headers: ["Accept", "Content-Type"], body: sessionRequest) { (response, error) in
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, nil)
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
                completion(decodedData, nil)
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityAPIErrorResponse.self, from: newData)
                    completion(nil, errorResponse)
                } catch {
                    print(error)
                }
            }
        }
        session.resume()
    }
    
    class func copiedFromDocumentation(_ data : Data) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        
//        request.httpBody = "{\"udacity\": {\"username\": \"scheer.charlie@gmail.com\", \"password\": \"raa8c4TEsUQRK2GvD(FnTEUD7\"}}".data(using: .utf8)
        request.httpBody = data
        let session = URLSession.shared
        print("pretask")
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print("error")
                print(error)
                return
            }
            let range = 5..<data!.count
            
            print("predata")
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
}

