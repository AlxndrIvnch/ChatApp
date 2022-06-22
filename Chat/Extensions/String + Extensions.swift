//
//  String + Extensions.swift
//  Chat
//
//  Created by Aleksandr on 16.06.2022.
//

import Foundation

extension String {
    
    private var gmail: String {
        return "@gmail.com"
    }
    
    private var textForChange: String {
        return "email address"
    }
    
    private var neededText: String {
        return "name"
    }
    
    mutating func mail() {
        self += gmail
    }
    
    mutating func unMail() {
        self.removeLast(gmail.count)
    }
    
    func mailed() -> String {
        return self + gmail
    }
    
    func unMailed() -> String {
        var text = self
        text.removeLast(gmail.count)
        return text
    }

    func changed() -> String {
        self.replacingOccurrences(of: textForChange, with: neededText)
    }
    
}
