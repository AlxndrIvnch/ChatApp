//
//  MainSceneCoordinator.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import Foundation
import UIKit

protocol MainFlowCoordinatorDelegat: AnyObject {
    func userDidLogout(coordinator: Coordinator)
}

class MainFlowCoordinator: Coordinator {
    
    //MARK: - Properties
    var childCoordinators: [Coordinator] = []
    private let navigationController = UINavigationController()
    private let window: UIWindow
    weak var delegate: MainFlowCoordinatorDelegat? //parentCoordinator
        
    //MARK: - Coordinator
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        setup()
        goToUsersListCoordinator()
    }
    
    private func setup() {
        if window.rootViewController == nil {
            
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
        } else {
            
            UIView.transition(with: window, duration: 0.4, options: .transitionCurlUp, animations: { [weak self] in
                self?.window.rootViewController = self?.navigationController
            }, completion: nil)
        }
    }
    
}

// MARK: - Navigation
extension MainFlowCoordinator {
    
    private func goToUsersListCoordinator() {
        let usersListCoordinator = UsersListCoordinator(navigationController: navigationController)
        usersListCoordinator.delegate = self
        childCoordinators.append(usersListCoordinator)
        usersListCoordinator.start()
    }
    
    private func goToChatCoordinator(with chatId: String?, and user: UserModel) {
        let chatCoordinator = ChatCoordinator(navigationController: navigationController, with: user, and: chatId)
        chatCoordinator.delegate = self
        childCoordinators.append(chatCoordinator)
        chatCoordinator.start()
    }

}

//MARK: - UsersListCoordinatorDelegat subscription
extension MainFlowCoordinator: UsersListCoordinatorDelegat {
    
    func userDidSellectUser(_ user: UserModel, with chatId: String?) {
        goToChatCoordinator(with: chatId, and: user)
    }
    
    func userDidLogout(coordinator: Coordinator) {
        removeChild(coordinator)
        delegate?.userDidLogout(coordinator: self)
    }

}

//MARK: - MainFlowCoordinatorDelegat subscription
extension MainFlowCoordinator: ChatCoordinatorDelegat {
    
    func userDidEndChat(coordinator: Coordinator) {
        removeChild(coordinator)
    }
}
