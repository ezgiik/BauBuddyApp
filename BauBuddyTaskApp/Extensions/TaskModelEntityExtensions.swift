//
//  TaskModelEntityExtensions.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 9.01.2024.
//

import Foundation
import CoreData


extension TaskModelEntity {
    func update(with task: Task) {
        self.task = task.task
        self.title = task.title
        self.taskDescription = task.description
        self.colorCode = task.colorCode
        self.businessUnit = task.businessUnit
        self.businessUnitKey = task.businessUnitKey
        self.wageType = task.wageType
        self.sort = task.sort
        self.parentTaskID = task.parentTaskID
        self.preplanningBoardQuickSelect = task.preplanningBoardQuickSelect
        self.workingTime = task.workingTime
        self.isAvailableInTimeTrackingKioskMode = task.isAvailableInTimeTrackingKioskMode
        
    }
}
