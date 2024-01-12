//
//  APIService.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import Foundation

class APIService {
    private let authService = AuthService()
    private let taskService = TaskService()

    func login(username: String, password: String, completion: @escaping (Result<Auth, Error>) -> Void) {
        authService.login(username: username, password: password) { result in
            switch result {
            case .success(let auth):
                completion(.success(auth))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTasks(auth: Auth, completion: @escaping (Result<[Task], Error>) -> Void) {
            taskService.fetchTasks(with: auth) { result in
                completion(result)
            }
        }


}
