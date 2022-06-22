//
//  UserModel.swift
//  Chat
//
//  Created by Aleksandr on 17.06.2022.
//

import Foundation

struct UserModel: Codable, Hashable {
    
    private(set) var id: String
    private(set) var name: String
    private(set) var creationTime: TimeInterval = Date().timeIntervalSince1970
    
    init(name: String) {
        id = UUID().uuidString
        self.name = name
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

}

