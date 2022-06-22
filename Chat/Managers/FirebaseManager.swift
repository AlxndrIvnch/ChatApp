//
//  FirebaseManager.swift
//  Chat
//
//  Created by Aleksandr on 17.06.2022.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

// RealTime DataBase link: https://console.firebase.google.com/u/2/project/chatfirebase-bff8c/database/chatfirebase-bff8c-default-rtdb/data

class FirebaseManager {
    
    let databaseUrl = "https://chatfirebase-bff8c-default-rtdb.europe-west1.firebasedatabase.app"

    let auth = Auth.auth()
    
    var sourceRef: DatabaseReference {
        return Database.database(url: databaseUrl).reference()
    }

    var usersRef: DatabaseReference {
        return sourceRef.child(Key.users.rawValue)
    }

    var chatsRef: DatabaseReference {
        return sourceRef.child(Key.chats.rawValue)
    }
    
}
