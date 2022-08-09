//
//  UserManager.swift
//  Chat
//
//  Created by Aleksandr on 17.06.2022.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import UIKit

final class UserManager: FirebaseManager {
    
    static let shared = UserManager()
    
    private override init() {}
    
    var currentUser: UserModel?

    
    func startFetchingUsers(completion: @escaping ItemClosure<[UserModel]>) {
        usersRef.observe(.value) { [weak self] snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let users = dict.map { (_, value) -> UserModel in
                    return try! UserModel(from: value)               
                }
                let usersWithOutMe = users.filter { $0.id != AuthManager.shared.currentUser?.uid }
                self?.currentUser = users.filter { $0.id == AuthManager.shared.currentUser?.uid }[0]
                completion(usersWithOutMe)
            }
        }
        
    }
    
    func stopFetchingUsers() {
        DispatchQueue.global().async { [weak self] in
            self?.usersRef.removeAllObservers()
        }
    }
    
}


