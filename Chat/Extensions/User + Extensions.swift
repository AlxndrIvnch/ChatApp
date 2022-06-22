//
//  User + Extensions.swift
//  Chat
//
//  Created by Aleksandr on 18.06.2022.
//

import Foundation
import FirebaseAuth

extension User {
    func toUserModel() -> UserModel {
        let id = self.uid
        let name = self.email?.unMailed()
        return UserModel(id: id, name: name ?? "name error")
    }
}
