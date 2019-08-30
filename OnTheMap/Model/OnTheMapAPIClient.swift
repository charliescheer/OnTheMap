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

        makePostRequest(url: Endpoints.login.url, requestType: UdacitySessionRequest.self, headers: ["Accept", "Content-Type"], body: sessionRequest) { (response, error) in
            if let response = response {
                competion(true, nil)
            } else {
                competion(false, error)
            }
        }
    }
    
    
    class func makePostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, requestType: ResponseType.Type, headers: [String], body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        print(url)
        request.httpMethod = "POST"
        for field in headers {
            request.addValue("application/json", forHTTPHeaderField: field)
            print(field)
        }
        

        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(body) else {
            return
        }
        
        print("did create data")
        request.httpBody = data
        
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("data was nil")
                return
            }
            
            if data.count == 0 {
                print("data was empty")
            } else {
                print(data)
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let json = try! JSONSerialization.jsonObject(with: newData, options: [])
            print(json)
            let decoder = JSONDecoder()
            
            
            do {
                let decodedData = try decoder.decode(UdacityAPIResponse.self, from: newData)
                print(decodedData)
            } catch {
                print(error)
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
    
    class func createJSONDataFromString() -> Data {
        guard let data = "{\"udacity\": {\"username\": \"scheer.charlie@gmail.com\", \"password\": \"raa8c4TEsUQRK2GvD(FnTEUD7\"}}".data(using: .utf8) else {
            return Data()
        }
        
        
        return data
    }
    
    class func createJSONDataFromObject() -> Data {
        let request = UdacitySessionRequest(username: "scheer.charlie@gmail.com", password: "raa8c4TEsUQRK2GvD(FnTEUD7")
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(request) else {
            return Data()
        }
        
        return data
    }
    
    class func decodeDummbyData(_ data: Data){
        print(data)
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] else {
            return
        }
        
        print(json)
    }
    
//    class func decodeTextData(_ data: Data){
//        print(data)
//        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject] else {
//            return
//        }
//
//        print(json)
//    }
    
}

