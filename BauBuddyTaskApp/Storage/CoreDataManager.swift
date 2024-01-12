//
//  CoreDataManager.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 9.01.2024.
//

import Foundation
import CoreData
import Reachability


class CoreDataManager {
    
    static let shared = CoreDataManager()

   var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

   lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()


   func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


    func isOffline() -> Bool {
        let reachability = try? Reachability()
        return reachability?.connection == .unavailable
    }


    func fetchTasks() -> [TaskModelEntity] {
        do {
            let fetchRequest: NSFetchRequest<TaskModelEntity> = TaskModelEntity.fetchRequest()
            return try context.fetch(fetchRequest)
            
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    func saveTasks(_ tasks: [Task]) {
        tasks.forEach { taskData in
            let taskEntity = TaskModelEntity(context: context)
            taskEntity.update(with: taskData)
        }
        saveContext()
    }
}

