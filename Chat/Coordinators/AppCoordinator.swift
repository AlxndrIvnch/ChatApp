//
//  AppCoordinator.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    private var window: UIWindow
    private var isLogedIn = false
    
    //MARK: - Coordinator
    init(winidow: UIWindow) {
        self.window = winidow
    }

    func start() {

        if AuthManager.shared.isLogged() {
            goToMainCoordinator()
        } else {
            goToAuthCoordinator()
        }
    }
}

// MARK: - Navigation
extension AppCoordinator {
    
    private func goToAuthCoordinator() {
        let authFlowCoordinator = AuthFlowCoordinator(window: window)
        authFlowCoordinator.delegate = self
        childCoordinators.append(authFlowCoordinator)
        authFlowCoordinator.start()
    }
    
    private func goToMainCoordinator() {
        let mainFlowCoordinator = MainFlowCoordinator(window: window)
        mainFlowCoordinator.delegate = self
        childCoordinators.append(mainFlowCoordinator)
        mainFlowCoordinator.start()
    }
    
}

//MARK: - AuthFlowCoordinatorDelegate subscription
extension AppCoordinator: AuthFlowCoordinatorDelegate {
    func userDidLogin(coordinator: Coordinator) {
        removeChild(coordinator)
        goToMainCoordinator()
    }
}

//MARK: - MainFlowCoordinatorDelegat subscription
extension AppCoordinator: MainFlowCoordinatorDelegat {
    func userDidLogout(coordinator: Coordinator) {
        removeChild(coordinator)
        goToAuthCoordinator()
    }

}
