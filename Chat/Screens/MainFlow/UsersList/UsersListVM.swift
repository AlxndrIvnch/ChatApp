//
//  UsersListVM.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import Foundation

protocol UsersListViewModelType {
    
    var viewDelegate: UsersListViewModelViewDelegate? { get set }
    
    func getNumberOfRows() -> Int
    
    func getUser(for index: Int) -> UserModel
    
    func getUnreadCount(for index: Int) -> Int
    
    func startUpdatingChatsActions()
    
    func startUpdatingUsers()
    
    func logoutButtonTapped()
    
    func rowTapped(_ row: Int)
}

protocol UsersListViewModelCoordinatorDelegate: AnyObject {
    func userDidLogout()
    
    func userDidSellectUser(_ user: UserModel, with chatId: String?)
}

protocol UsersListViewModelViewDelegate: AnyObject {
    
    var viewModel: UsersListViewModelType? { get set }
    
    func updateTable()
}

class UsersListVM {
    
    // MARK: - Delegates
    private weak var coordinatorDelegate: UsersListViewModelCoordinatorDelegate!
    
    weak var viewDelegate: UsersListViewModelViewDelegate?
    
    // MARK: - Properties
    private var users: [UserModel] = [] {
        didSet {
            viewDelegate?.updateTable()
        }
    }
    
    private var chats: [Chat] = []
    
    private var dictUnreadCount = [String: Int]()
    
    init(coordintaor: UsersListViewModelCoordinatorDelegate) {
        
        self.coordinatorDelegate = coordintaor
    }
}

extension UsersListVM: UsersListViewModelType {
    
    // MARK: - Data Source
    
    func startUpdatingUsers() {
        
        UserManager.shared.startFetchingUsers { [weak self] users in
            ChatManager.shared.loadChats { chats in
                
                guard let self = self else { return }
                guard let currentUser = UserManager.shared.currentUser else { return }
                
                var dictForSorting = [String: TimeInterval]()
                var currentChats = [Chat]()
                
                for user in users {
                    
                    let meAndOtherUser = [currentUser, user]
                    
                    let filtredChat = chats.filter { chat in

                        let opponents = chat.getOpponents()

                        return Set(meAndOtherUser).symmetricDifference(opponents).count == 0
                    }
                    
                    guard filtredChat.count <= 1 else { fatalError("Error, chats more than one") }
                    
                    if let chat = filtredChat.first {
                        
                        currentChats.append(chat)
                        self.loadUnreadMessages(from: chat)

                        guard let time = chat.lastActionTime else { return }

                        if chat.getMessages().count > 1 {
                            dictForSorting.updateValue(time, forKey: user.id)
                        }
                    }
                    
                    if dictForSorting[user.id] == nil {
                        
                        dictForSorting.updateValue(user.creationTime, forKey: user.id)
                    }
                }
                self.chats = currentChats
                self.users = users.sorted { user1, user2 in
                    return dictForSorting[user1.id]! > dictForSorting[user2.id]!
                }
            }
        }
    }
    
    func loadUnreadMessages(from chat: Chat) {
        
        let messages = chat.getMessages()
        
        let filtredMessages = messages.filter { message in
            return message.isReaded == false && message.isSenderOpponent
        }
        
        if let opponent = chat.getOpponent() {
            dictUnreadCount.updateValue(filtredMessages.count, forKey: opponent.id)
        }
    }
    
    func startUpdatingChatsActions() {
        
        ChatManager.shared.startFetchingLastActiveChat { [weak self] chat in
  
            guard let self = self else { return }
        
            let opponents = chat.getOpponents()
            guard let currentUser = UserManager.shared.currentUser else { return }
            guard opponents.contains(currentUser) else { return }
            guard let opponent = opponents.first(where: { $0.id != currentUser.id }) else { return }
            
            if !self.chats.contains(where: { $0.id == chat.id }) {
                self.chats.append(chat)
            }
            
            if chat.getMessages().count > 1 {
                self.loadUnreadMessages(from: chat)
                self.users.removeAll(where: { $0.id == opponent.id })
                self.users.insert(opponent, at: 0)
            }
        }
    }
    
    func getNumberOfRows() -> Int {
        return users.count
    }
    
    func getUser(for index: Int) -> UserModel {
        return users[index]
    }
    
    func getUnreadCount(for index: Int) -> Int {
        
        let userId = users[index].id
        let count = dictUnreadCount[userId]
        
        return count ?? 0
        
    }
    
    // MARK: - Events
    
    func logoutButtonTapped() {
        ChatManager.shared.stopFetchingChats()
        UserManager.shared.stopFetchingUsers()
        if AuthManager.shared.logout() {
            coordinatorDelegate.userDidLogout()
        }
    }
    
    func rowTapped(_ row: Int) {
        let user = users[row]
        let chat = chats.first { $0.getOpponent()?.id == user.id }
        coordinatorDelegate.userDidSellectUser(user, with: chat?.id)
    }
}
