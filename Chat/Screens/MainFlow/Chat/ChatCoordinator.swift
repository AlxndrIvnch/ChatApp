//
//  ChatCoordinator.swift
//  Chat
//
//  Created by Aleksandr on 15.06.2022.
//

import Foundation
import UIKit

protocol ChatCoordinatorDelegat: AnyObject {
    func userDidEndChat(coordinator: Coordinator)
}

class ChatCoordinator: Coordinator {
    
    //MARK: - Properties
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    weak var delegate: ChatCoordinatorDelegat? //parentCoordinator
    private let storyboard = Storyboard.main
    private var user: UserModel
    private var chatId: String?
 
    
    //MARK: - Coordinator
    init(navigationController: UINavigationController, with user: UserModel, and chatId: String?) {
        
        self.navigationController = navigationController
        self.user = user
        self.chatId = chatId
    }
    
    func start() {
        goToChat(with: user)
    }
}

// MARK: - Navigation
extension ChatCoordinator {
    
    private func goToChat(with user: UserModel) {
        let vc = storyboard.controller(of: ChatVC.self)
        let vm = ChatVM(with: user, and: chatId, coordintaor: self)
        vc.viewModel = vm
        navigationController.pushViewController(vc, animated: true)
    }
    
}

// MARK: - ChatViewModelCoordinatorDelegate subscription
extension ChatCoordinator: ChatViewModelCoordinatorDelegate {
    func userDidEndChat() {
        delegate?.userDidEndChat(coordinator: self)
    }
    
}
