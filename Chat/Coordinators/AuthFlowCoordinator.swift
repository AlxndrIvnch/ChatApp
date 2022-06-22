//
//  AuthSceneCoordinator.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import Foundation
import UIKit

protocol AuthFlowCoordinatorDelegate: AnyObject {
    func userDidLogin(coordinator: Coordinator)
}

class AuthFlowCoordinator: Coordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    private let navigationController = UINavigationController()
    private let window: UIWindow
    weak var delegate: AuthFlowCoordinatorDelegate? //parentCoordinator
    
    //MARK: - Coordinator
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        
        setup()
        goToSignInCoordinator()
    }
    
    func finish() {

    }
    
    private func setup() {
        if window.rootViewController == nil {
            
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
        } else {
            
            UIView.transition(with: window, duration: 0.4, options: .transitionCurlDown, animations: { [weak self] in
                self?.window.rootViewController = self?.navigationController
            }, completion: nil)
        }
    }
    
}

// MARK: - Navigation
extension AuthFlowCoordinator {
    
    private func goToSignInCoordinator() {
        let signInCoordinator = SignInCoordinator(navigationController: navigationController)
        signInCoordinator.delegate = self
        childCoordinators.append(signInCoordinator)
        signInCoordinator.start()
    }
}

//MARK: - AuthSceneCoordinatorDelegate subscription
extension AuthFlowCoordinator: SignInCoordinatorDelegate {
    func userDidLogin(coordinator: Coordinator) {
        removeChild(coordinator)
        delegate?.userDidLogin(coordinator: self)
    }
}


