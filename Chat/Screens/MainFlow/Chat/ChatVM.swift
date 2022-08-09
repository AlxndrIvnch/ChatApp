//
//  ChatVM.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import Foundation

protocol ChatViewModelType {
    
    var updateTable: VoidClouser? { get set }
    
    var scrollToRow: ((_ row: Int, _ animated: Bool) -> Void)? { get set }
    
    func backButtonTapped()
    
    func getOpponentName() -> String
    
    func startLoadingMessages()
    
    func getMessage(for row: Int) -> Message?
    
    func configurePagination(with type: PaginationType)
    
    func getNumberOfRows() -> Int
    
    func sendButtonTapped(with text: String?)
    
    func readMessages(with indexes: [IndexPath]?)
    
}

protocol ChatViewModelCoordinatorDelegate: AnyObject {
    func userDidEndChat()
}

class ChatVM {
    
    // MARK: - Properties
    private weak var coordinatorDelegate: ChatViewModelCoordinatorDelegate!
    
    private let opponent: UserModel!
    
    var currentUser: UserModel! {
        return UserManager.shared.currentUser
    }
    
    private var chatId: String?
    
    private var scrollToUnreadMessage: Bool = true
    
    private var currentMessages: [Message] = [] {
        didSet {
            var messages = currentMessages
            guard !messages.isEmpty else { return }
            
            var uniqMessages = [Message]()
            for message in messages {
                if !uniqMessages.contains(where: { $0.id == message.id }) {
                    uniqMessages.append(message)
                }
            }
            messages = uniqMessages
            messages = messages.sorted { $0.time > $1.time }
            currentMessages = messages

            configureScrollingtoFirstUnreadMessage()
        }
    }
    
    private var messagesLimit = 30
    
    private var isPaginating = false
    
    var updateTable: VoidClouser?
    
    var scrollToRow: ((Int, Bool) -> Void)?
    
    init(with user: UserModel, and chatId: String?, coordintaor: ChatViewModelCoordinatorDelegate) {
        
        self.chatId = chatId
        self.coordinatorDelegate = coordintaor
        self.opponent = user
    }
    
    func createChat() -> Chat {
        return Chat(opponents: [currentUser, opponent])
    }
    
    func createMessage(with text: String) -> Message {
        return Message(text: text)
    }
    
    
    func configureScrollingtoFirstUnreadMessage() {
        guard let lastMessage = currentMessages.last(where: { !$0.isEndMessage }) else { return }
        
        if !lastMessage.isReaded && lastMessage.isSenderOpponent && !currentMessages.last!.isEndMessage {
            configurePagination(with: .increase)
            
        } else {
            
            updateTable?()
            
            guard scrollToUnreadMessage else { return }
            scrollToUnreadMessage.toggle()
            
            guard let index = currentMessages.lastIndex(where: { !$0.isReaded && $0.isSenderOpponent }) else { return }
            scrollToRow?(index, false)
            
        }
    }
}

extension ChatVM: ChatViewModelType {
    
    // MARK: - Data Source
    
    func getNumberOfRows() -> Int {
        var messages = currentMessages
        guard let lastMessage = messages.last else { return 0 }
        if lastMessage.isEndMessage {
            messages.removeLast()
        }
        return currentMessages.isEmpty ? 0 : currentMessages.count - 1
    }
    
    func getMessage(for row: Int) -> Message? {

        var messages = currentMessages
        guard let lastMessage = messages.last else { return nil }
        if lastMessage.isEndMessage {
            messages.removeLast()
        }
        return messages[row]
    }
    
    func configurePagination(with type: PaginationType) {
        
        guard !isPaginating else { return }
        
        guard let lastMessage = currentMessages.last else { return }
        guard !lastMessage.isEndMessage else { return }
        
        guard let chatId = chatId else { return }
        
        isPaginating = true
        
        switch type {
        case .increase: messagesLimit += 30
        case .decrease: messagesLimit -= 30
        }

        ChatManager.shared.loadNextMessagesFromChat(with: chatId, limit: messagesLimit, lastFechedMessageId: lastMessage.id) { [weak self] messages in
            
            self?.isPaginating = false
            self?.currentMessages = messages

        }
    }
    
    func getOpponentName() -> String {
        return opponent.name
    }
    
    func startLoadingMessages() {

        if self.chatId == nil {
            let chat = self.createChat()
            self.chatId = chat.id
            
            ChatManager.shared.saveChat(chat)
        }
        
        guard let chatId = self.chatId else { fatalError() }

        ChatManager.shared.loadMessagesFromChat(with: chatId, limit: 30) { messages in
            self.currentMessages = messages
            
        }
  
        ChatManager.shared.startFetchingNewMessageFromChat(with: chatId) { message in
            self.currentMessages.append(message)

        }
    }
    
    func readMessages(with indexes: [IndexPath]?) {
        
        guard let chatId = self.chatId else { return }
        guard !currentMessages.isEmpty else { return }
        
        guard let rows = indexes?.map({ index -> Int in
            return index.row
        }) else { return }
                
        var messagesOnScreen = [Message]()
        for row in rows {
            messagesOnScreen.append(currentMessages[row])
        }
        
        let unreadedMessages = messagesOnScreen.filter({ $0.isReaded == false && $0.isSenderOpponent })
        ChatManager.shared.setIsRead(for: unreadedMessages, with: chatId)
    }
    

    
    // MARK: - Events
    
    func sendButtonTapped(with text: String?) {
        
        guard let text = text else { return }
        let message = createMessage(with: text)
        
        guard let chatId = self.chatId else { fatalError() }
        ChatManager.shared.sendMessage(message, toChatWith: chatId)
        ChatManager.shared.updateLastActionTime(of: chatId, with: message.time)
        
        guard currentMessages.count > 1 else { return }
    
        scrollToRow?(0, false)
        let unreadedMessages = currentMessages.filter({ $0.isReaded == false && $0.isSenderOpponent })
        guard !unreadedMessages.isEmpty else { return }
        ChatManager.shared.setIsRead(for: unreadedMessages, with: chatId)
        
        
        
    }
    
    func backButtonTapped() {
        guard let chatId = self.chatId else { return }
        ChatManager.shared.stopFetchingMessagesFromChat(with: chatId)
        coordinatorDelegate.userDidEndChat()
    }
     
}
