//
//  ChatManager.swift
//  Chat
//
//  Created by Aleksandr on 17.06.2022.
//
import Firebase
import Foundation

class ChatManager: FirebaseManager {
    
    static let shared = ChatManager()
    
    private override init() {}
        
    func loadChats(completion: @escaping ItemClosure<[Chat]>) {
        DispatchQueue.global().async { [weak self] in
            self?.chatsRef.observeSingleEvent(of: .value) { snapshot in
                if let dict = snapshot.value as? [String: [String: Any]] {
                    let chats = dict.map { (_, value) -> Chat in
                        return try! Chat(from: value)
                    }
                    DispatchQueue.main.async {
                        completion(chats)
                    }
                }
            }
        }
    }
    
    func loadChat(of firstUser: UserModel = UserManager.shared.currentUser!, and secondUser: UserModel, completion: @escaping ItemClosure<Chat?>) {
        let meAndOtherUser = [firstUser, secondUser]
        
        loadChats { chats in
            let filtredChats = chats.filter { chat in
                let opponents = chat.getOpponents()
                
                return Set(meAndOtherUser).symmetricDifference(opponents).count == 0
            }
            
            if filtredChats.isEmpty {
                completion(nil)
                return
            }
            guard filtredChats.count == 1 else { fatalError("Error, chats more than one") }
            guard let neededChat = filtredChats.first else { fatalError() }
            
            completion(neededChat)
        }
        
    }

    
    func loadChatId(of firstUser: UserModel = UserManager.shared.currentUser!, and secondUser: UserModel, completion: @escaping ItemClosure<String?>) {
        
        loadChat(of: firstUser, and: secondUser) { chat in
            completion(chat?.id)
        }
        
    }
    
    func updateLastActionTime(of chatId: String, with time: TimeInterval) {
        DispatchQueue.global().async { [weak self] in
            self?.chatsRef.child(chatId).updateChildValues([Key.lastActionTime.rawValue : time])
        }
    }
    
    func saveChat(_ chat: Chat) {
        DispatchQueue.global().async { [weak self] in
            let dict = chat.dictionary
            self?.chatsRef.child(chat.id).setValue(dict)
        }
    }
    
    func sendMessage(_ message: Message, toChatWith chatId: String) {
        DispatchQueue.global().async { [weak self] in
            let messageId = message.id
            let messageDict = message.dictionary
            
            self?.chatsRef.child(chatId).child(Key.messages.rawValue).child(messageId).setValue(messageDict)
        }
    }
    
    func startFetchingLastActiveChat(completion: @escaping ItemClosure<Chat>) {
        DispatchQueue.global().async { [weak self] in
            self?.chatsRef.queryOrdered(byChild: Key.lastActionTime.rawValue).queryLimited(toLast: 1).observe(.value) { snapshot in
                
                if let dict = snapshot.value as? [String: [String: Any]] {
                    let chats = dict.map { (_, value) -> Chat in
                        return try! Chat(from: value)
                    }
                    DispatchQueue.main.async {
                        completion(chats.first!)
                    }
                }
            }
        }
    }

    func loadMessagesFromChat(with chatId: String, limit: Int, completion: @escaping ItemClosure<[Message]>) {
        DispatchQueue.global().async { [weak self] in
            self?.chatsRef.child(chatId).child(Key.messages.rawValue).queryOrdered(byChild: Key.time.rawValue).queryLimited(toLast: UInt(limit)).observeSingleEvent(of: .value) { snapshot in
 
                if let dict = snapshot.value as? [String: [String: Any]] {
                    let messages = dict.map { (_, value) -> Message in
                        return try! Message(from: value)
                    }
                    DispatchQueue.main.async {
                        completion(messages)
                    }
                }
            }
        }
    }
    
    func startFetchingNewMessageFromChat(with chatId: String, completion: @escaping ItemClosure<Message>) {
        DispatchQueue.global().async { [weak self] in
            self?.chatsRef.child(chatId).child(Key.messages.rawValue).queryOrdered(byChild: Key.time.rawValue).queryLimited(toLast: 1).observe(.value) { snapshot in
                
                if let dict = snapshot.value as? [String: [String: Any]] {
                    let messages = dict.map { (_, value) -> Message in
                        return try! Message(from: value)
                    }
                    DispatchQueue.main.async {
                        completion(messages[0])
                    }
                }
            }
        }
    }
    
    func loadNextMessagesFromChat(with chatId: String, limit: Int, lastFechedMessageId: String, completion: @escaping ItemClosure<[Message]>) {
        DispatchQueue.global().async { [weak self] in
            self?.chatsRef.child(chatId).child(Key.messages.rawValue).queryOrdered(byChild: Key.time.rawValue).queryEnding(atValue: lastFechedMessageId).queryLimited(toLast: UInt(limit)).observeSingleEvent(of: .value) { snapshot in

                if let dict = snapshot.value as? [String: [String: Any]] {
                    let messages = dict.map { (_, value) -> Message in
                        return try! Message(from: value)
                    }
                    DispatchQueue.main.async {
                        completion(messages)
                    }
                }
            }
        }
    }
    
    
    func stopFetchingMessagesFromChat(with chatId: String) {
        
        DispatchQueue.global().async { [weak self] in
            self?.chatsRef.child(chatId).child(Key.messages.rawValue).removeAllObservers()
        }
    }
    
    func stopFetchingChats() {
        
        DispatchQueue.global().async { [weak self] in
            self?.chatsRef.removeAllObservers()
        }
    }
    
    func setIsRead(for messages: [Message], with chatId: String) {
        guard  !messages.isEmpty else { return }
        DispatchQueue.global().async { [weak self] in

            for message in messages {
                self?.chatsRef.child(chatId).child(Key.messages.rawValue).child(message.id).child(Key.isReaded.rawValue).setValue(true)
            }
        }
    }
}

