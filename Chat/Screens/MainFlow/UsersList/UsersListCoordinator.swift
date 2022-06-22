//
//  UsersListCoordinator.swift
//  Chat
//
//  Created by Aleksandr on 15.06.2022.
//

import Foundation
import UIKit

protocol UsersListCoordinatorDelegat: AnyObject {
    func userDidLogout(coordinator: Coordinator)
    
    func userDidSellectUser(_ user: UserModel, with chatId: String?)
}

class UsersListCoordinator: Coordinator {
    
    //MARK: - Properties
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    weak var delegate: UsersListCoordinatorDelegat? //parentCoordinator
    private let storyboard = Storyboard.main
    
    
    //MARK: - Coordinator
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToUsersList()
    }
    
}

// MARK: - Navigation
extension UsersListCoordinator {
    
    private func goToUsersList() {
        let vm = UsersListVM(coordintaor: self)
        let vc = storyboard.controller(of: UsersListVC.self)
        vc.viewModel = vm
        navigationController.setViewControllers([vc], animated: true)
    }
}

// MARK: - UsersListViewModelCoordinatorDelegate subscription
extension UsersListCoordinator: UsersListViewModelCoordinatorDelegate {
    
    func userDidSellectUser(_ user: UserModel, with chatId: String?) {
        delegate?.userDidSellectUser(user, with: chatId)
    }
    
    func userDidLogout() {
        delegate?.userDidLogout(coordinator: self)
    }
}

