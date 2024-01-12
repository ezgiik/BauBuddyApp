//
//  Auth.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import Foundation

class Auth: Codable {
    var accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
}
