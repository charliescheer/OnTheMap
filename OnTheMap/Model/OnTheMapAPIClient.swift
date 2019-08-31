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
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.baseURL + "session"
            case .signup: return "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
            case .logout: return Endpoints.baseURL + "session"
            case .getUserData: return Endpoints.baseURL + "users/" + Auth.key
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
                Auth.key = response.account.key
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
            //Remove the first 5 characters from data per Udacity security spac
            //Decode data and return the resonse to the completion handler
            guard let data = removeSecurityDataFromResponseData(data) else {
                print("data was nil")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let decodedData = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UdacityAPIErrorResponse.self, from: data)
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
    
    class func getLoggedInUserData(url: URL, userId: String) {
        //Check to make sure the saved UserId is not empty
        guard userId.count != 0 else {
            print("no user id")
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = removeSecurityDataFromResponseData(data) else {
                print("data modification failed")
                return
            }
        
            let decoder = JSONDecoder()
            
            do {
                let loggedInUser = try decoder.decode(User.self, from: data)
                print(loggedInUser.firstName + " " + loggedInUser.lastName)
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
}

