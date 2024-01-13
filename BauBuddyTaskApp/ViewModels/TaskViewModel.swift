//
//  TaskViewModel.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import Foundation


class TaskViewModel {
    var tasks: [Task] = []
    
    func fetchTasks(auth: Auth, completion: @escaping (Result<[Task], Error>) -> Void) {
        if CoreDataManager.shared.isOffline() {
            
            let coreDataTasks = CoreDataManager.shared.fetchTasks()
            self.tasks = coreDataTasks.map { Task(from: $0) }
            completion(.success(self.tasks))
        } else {
            
            let taskService = TaskService()
            taskService.fetchTasks(with: auth) { [weak self] result in
                switch result {
                case .success(let fetchedTasks):
                    self?.tasks = fetchedTasks
                    
                    CoreDataManager.shared.saveTasks(fetchedTasks)
                    completion(.success(fetchedTasks))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

