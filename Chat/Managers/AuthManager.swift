//
//  AuthManager.swift
//  Chat
//
//  Created by Aleksandr on 16.06.2022.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import ARSLineProgress

class AuthManager: FirebaseManager {
    
    static let shared = AuthManager()
    
    private override init() {}
    
    private let password = "123456" //any password, beacouse we don't need password in app now, but 6 characters long or more is Firebase requirement
    
    var currentUser: User? {
        return auth.currentUser
    }

    func signUp(with model: UserModel, completion: @escaping ItemClosure<Result>) {
        
        let mailedName = model.name.mailed()

        auth.createUser(withEmail: mailedName, password: password) { [weak self] result, error in

            if let error = error {
                completion(.error(error.localizedDescription))
                return
            }
            guard let result = result else {
                return
            }
            let id = result.user.uid
            var dictionary = model.dictionary
            dictionary?[Key.id.rawValue] = id
            
            self?.usersRef.child(id).setValue(dictionary)
            completion(.success)
            
        }

    }
    
    func signIn(with model: UserModel, completion: @escaping ItemClosure<Result>) {
        
        let mailedName = model.name.mailed()

        auth.signIn(withEmail: mailedName, password: password) { result, error in
            if let error = error {
                completion(.error(error.localizedDescription))
                return
            }
            completion(.success)
        }
    }
    
    func isLogged() -> Bool {
        return currentUser != nil
    }
    
    func logout() -> Bool {
        do {
            try auth.signOut()
        } catch {
            return false
        }
        return true
    }

}
