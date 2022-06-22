//
//  Message.swift
//  Chat
//
//  Created by Aleksandr on 17.06.2022.
//

import Foundation

struct Message: Codable, Hashable {
    
    private(set) var id: String = UUID().uuidString
    private(set) var senderId: String!
    private(set) var text: String!
    private(set) var time: TimeInterval
    private(set) var isReaded: Bool = false
    
    var isSenderOpponent: Bool {
        return senderId != UserManager.shared.currentUser?.id
    }
    
    var isEndMessage: Bool {
        return self.id == Key.MFM.rawValue
    }
    
    init(text: String) {
        self.senderId = UserManager.shared.currentUser?.id
        self.text = text
        time = Date().timeIntervalSince1970
    }
    init(text: String, id: String, isReaded: Bool) {
        self.isReaded = isReaded
        self.id = id
        self.senderId = UserManager.shared.currentUser?.id
        self.text = text
        time = 0
    }
    
    func getFormattedTime() -> String {
        let date = Date(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
        
    }
}
