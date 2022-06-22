//
//  Chat.swift
//  Chat
//
//  Created by Aleksandr on 18.06.2022.
//

import Foundation

struct Chat: Codable {
    
    private(set) var id: String = UUID().uuidString
    private var messages = [String: Message]()
    private var opponents = [String: UserModel]()
    private(set) var lastActionTime: TimeInterval!

    init(opponents: [UserModel]) {
        addOpponents(opponents)
        lastActionTime = Date().timeIntervalSince1970
        let firstMessage = Message(text: Key.MFM.rawValue, id: Key.MFM.rawValue, isReaded: true)
        addMessage(firstMessage)
    }
    
    func getMessages() -> [Message] {
        return messages.map { (_, value) -> Message in
            return value
        }
    }
    
    func getOpponent() -> UserModel? {
        guard let opponent = opponents.first(where: { $0.value.id != UserManager.shared.currentUser?.id })?.value else { return nil }
        return opponent
    }
    
    func getOpponents() -> [UserModel] {
        return opponents.map { (_, value) -> UserModel in
            return value
        }
    }
    
    mutating func addOpponent(_ opponent: UserModel) {
        let id = opponent.id
        opponents.updateValue(opponent, forKey: id)
    }
    
    mutating func addOpponents(_ opponents: [UserModel]) {
        for opponent in opponents {
            addOpponent(opponent)
        }
    }
    
    mutating func addMessage(_ message: Message) {
        let messageId = message.id
        messages.updateValue(message, forKey: messageId)
    }
    
}

