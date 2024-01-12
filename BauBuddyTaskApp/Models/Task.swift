//
//  Task.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import Foundation


struct Task: Codable {
    var task: String?
    var title: String?
    var description: String?
    var colorCode: String?
    var businessUnit: String?
    var businessUnitKey: String?
    var wageType: String?
    var sort: String?
    var parentTaskID: String?
    var preplanningBoardQuickSelect: String?
    var workingTime: String?
    var isAvailableInTimeTrackingKioskMode: Bool


   
    init(from entity: TaskModelEntity) {
        self.task = entity.task
        self.title = entity.title
        self.description = entity.taskDescription 
        self.colorCode = entity.colorCode
        self.businessUnit = entity.businessUnit
        self.businessUnitKey = entity.businessUnitKey
        self.wageType = entity.wageType
        self.sort = entity.sort
        self.parentTaskID = entity.parentTaskID
        self.preplanningBoardQuickSelect = entity.preplanningBoardQuickSelect
        self.workingTime = entity.workingTime
        self.isAvailableInTimeTrackingKioskMode = entity.isAvailableInTimeTrackingKioskMode
    }
}

