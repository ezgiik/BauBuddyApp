//
//  AuthService.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import Foundation

class AuthService {
    func login(username: String, password: String, completion: @escaping (Result<Auth, Error>) -> Void) {
        let headers = [
            "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "username": username,
            "password": password
        ] as [String: Any]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            let error = NSError(domain: "LoginErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error serializing JSON"])
            completion(.failure(error))
            return
        }
        
        guard let url = URL(string: "https://api.baubuddy.de/index.php/login") else {
            let error = NSError(domain: "LoginErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                let error = NSError(domain: "LoginErrorDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid response or status code"])
                completion(.failure(error))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let oauth = json["oauth"] as? [String: Any],
                   let accessToken = oauth["access_token"] as? String {
                    
                    let auth = Auth(accessToken: accessToken)
                    self.saveToken(accessToken) 
                    completion(.success(auth))
                } else {
                    let error = NSError(domain: "LoginErrorDomain", code: 3, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON format or missing keys"])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    func logout() {
            UserDefaults.standard.removeObject(forKey: "accessToken")
            
        }
}

extension AuthService {
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
    }
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
}
