//
//  TaskService.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import Foundation

class TaskService {
    func fetchTasks(with auth: Auth, completion: @escaping (Result<[Task], Error>) -> Void) {
        let url = URL(string: "https://api.baubuddy.de/dev/index.php/v1/tasks/select")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(auth.accessToken)", forHTTPHeaderField: "Authorization")


       let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let tasks = try JSONDecoder().decode([Task].self, from: data)
                    completion(.success(tasks))
                } catch {
                    completion(.failure(error))
                }
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    DispatchQueue.main.async {
                        // Here you would need to implement the logic to redirect to the LoginView.
                        // For example, you can use NotificationCenter to post a notification
                        // that the SceneDelegate or AppDelegate listens for to change the rootViewController,
                        // or if you have a reference to the navigationController you can pop to the desired viewController.
                        NotificationCenter.default.post(name: NSNotification.Name("UnauthorizedAccessDetected"), object: nil)
                    }
                }
            }
        }


       dataTask.resume()
    }
}
