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
        static var key = ""
    }
    
    enum Endpoints {
        static let baseURL =  "https://onthemap-api.udacity.com/v1/"
        
        case login
        case signup
        case logout
        case getUserData
        case getStudentLocation
        case postStudentLocation
        case putStudentLocation
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.baseURL + "session"
            case .signup: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            case .logout: return Endpoints.baseURL + "session"
            case .getUserData: return Endpoints.baseURL + "users/" + Auth.key
            case .getStudentLocation: return Endpoints.baseURL + "StudentLocation" + "?limit=100"
            case .postStudentLocation: return Endpoints.baseURL + "StudentLocation"
            case .putStudentLocation: return Endpoints.baseURL + "StudentLocation/" + Auth.key
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func makePostRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, headers: [String], body: RequestType, secureReturn: Bool, completion: @escaping (ResponseType?, Error?) -> Void ) {
        
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
            var mutableData = Data()
            //Check to make sure the data returned is not nil and is not empty
            //Remove the first 5 characters from data per Udacity security spac
            //Decode data and return the resonse to the completion handler
            if secureReturn {
                guard let tempData = removeSecurityDataFromResponseData(data) else {
                    DispatchQueue.main.async {
                        print("no data")
                        completion(nil, error)
                    }
                    return
                }
                mutableData = tempData
            } else {
                guard let tempData = data else {
                    DispatchQueue.main.async {
                        print("no data")
                        completion(nil, error)
                    }
                    return
                }
                mutableData = tempData
            }
            
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(ResponseType.self, from: mutableData)
                DispatchQueue.main.async {
                    completion(decodedData, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityAPIErrorResponse.self, from: mutableData)
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
    
    class func taskForDeleteRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = removeSecurityDataFromResponseData(data) else {
                return
            }
            
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityAPIErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    print("here?")
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, secureReturn: Bool, completion: @escaping (ResponseType?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var mutableData = Data()
            
            if secureReturn {
                guard let tempData = removeSecurityDataFromResponseData(data) else {
                    DispatchQueue.main.async {
                        print("no data")
                        completion(nil, error)
                    }
                    return
                }
                mutableData = tempData
            } else {
                guard let tempData = data else {
                    DispatchQueue.main.async {
                        print("no data")
                        completion(nil, error)
                    }
                    return
                }
                mutableData = tempData
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(ResponseType.self, from: mutableData)
                
                DispatchQueue.main.async {
                    completion(response, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityAPIErrorResponse.self, from: mutableData)
                    
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
                
            }
        }
        task.resume()
    }
    
    class func taskForPutRequest<ResponseType: Decodable, RequestType: Encodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(body) else {
            print("Could not convert to JSON")
            return
        }
        request.httpBody = data
        print(request)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(json)
            
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(ResponseType.self, from: data)
                completion(decodedData, nil)
            } catch {
                do {
                    let decodedError = try decoder.decode(UdacityAPIPutErrorResponse.self, from: data)
                    completion(nil, decodedError)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        task.resume()
        
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let sessionRequest = UdacitySessionRequest(username: username, password: password)
        
        makePostRequest(url: Endpoints.login.url, responseType: UdacityAPILoginResponse.self, headers: ["Accept", "Content-Type"], body: sessionRequest, secureReturn: true) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.sessionId
                Auth.key = response.account.key
                
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
                    completion(false, error)
                }
            }
        }
    }
    
    class func Logout(completion: @escaping (Bool, Error?) -> Void) {
        taskForDeleteRequest(url: OnTheMapAPIClient.Endpoints.logout.url, responseType: UdacityAPILogoutResponse.self) { (response, error) in
            if let response = response {
                UserDefaults.standard.set(nil, forKey: "sessionId")
                print(response.session.sessionId)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    class func getStudentLocations(completion: @escaping (Bool, [StudentLocationResults]?, Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getStudentLocation.url, responseType: StudentLocation.self, secureReturn: false) { (response, error) in
            if let response = response {
                DispatchQueue.main.async {
                    completion(true, response.results, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completion(false, nil, nil)
                }
            }
        }
    }
    
    
    //Takes optional data and confirms the data is not nil
    //If the data is not nil, checks to see if the data is not empty
    //If both checks pass, removes the frist five characters from the data and returns the new data
    class func removeSecurityDataFromResponseData(_ data: Data?) -> Data? {
        guard let data = data else {
            return nil
        }
        
        guard data.count != 0 else {
            print("The data received from the server was empty")
            return nil
        }
        
        let range = 5..<data.count
        
        return data.subdata(in: range)
    }
    
    //Checks user defaults to see if there is saved data for the logged in user
    class func authSessionIdIsSavedToUserDefaults() -> Bool {
        guard (UserDefaults.standard.data(forKey: "sessionId") != nil) else {
            print("No Saved Data")
            return false
        }
        
        return true
    }
    
    //Check to see if there is saved data in Userdefaults for the sessionId
    class func setSavedAuthSessionIdandUserID() {
        guard let data = UserDefaults.standard.data(forKey: "sessionId") else {
            print("No Saved Data")
            return
        }
    
        let decoder = PropertyListDecoder()
        do {
            
            let decodedResponse = try decoder.decode(UdacityAPILoginResponse.self, from: data)
            Auth.sessionId = decodedResponse.session.sessionId
            Auth.key = decodedResponse.account.key
            print(Auth.sessionId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func getLoggedinUserData(completion: @escaping (Bool, User?, Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getUserData.url, responseType: User.self, secureReturn: true) { (response, error) in
            guard let user = response else {
                print("Could not access user info")
                completion(false, nil, error)
                return
            }
            
            completion(true, user, nil)
        }
    }
    
    class func postLoggedInUserLocation(body: StudentLocationResults, completion: @escaping (Bool, Error?) -> Void) {
        
        makePostRequest(url: Endpoints.postStudentLocation.url, responseType: UdacityAPIPostLocationResponse.self, headers: ["Content-Type"], body: body, secureReturn: false) { (response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                    return
                }
            } else {
                DispatchQueue.main.async {
                    let encoder = PropertyListEncoder()
                    do {
                        let encodedData = try encoder.encode(body)
                        UserDefaults.standard.set(encodedData, forKey: constants.loggedInUserLocation)
                        print("saved user location")
                    } catch {
                        print(error)
                    }
                    completion(true, nil)
                    print(response?.objectId ?? "couldn't get objectId")
                }
            }
            
            print(response?.objectId ?? "couldn't get objectId")
        }
    }
    
    class func putLoggedInUserLocation(body: StudentLocationResults, completion: @escaping (Bool, Error?) -> Void) {
        taskForPutRequest(url: Endpoints.putStudentLocation.url, responseType: UdacityAPIUpdateResponse.self, body: body) { (response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    completion(false, error)
                    return
                }
            } else {
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            }
        }
    }
}

extension OnTheMapAPIClient {
    enum constants {
        static let loggedInUserLocation = "loggedUserLocation"
    }
}

