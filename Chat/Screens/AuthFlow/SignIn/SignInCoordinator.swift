//
//  SignInCoordinator.swift
//  Chat
//
//  Created by Aleksandr on 15.06.2022.
//

import Foundation
import UIKit

protocol SignInCoordinatorDelegate: AnyObject {
    func userDidLogin(coordinator: Coordinator)
}

class SignInCoordinator: Coordinator {
    
    // MARK: - Properties
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    weak var delegate: SignInCoordinatorDelegate? //parentCoordinator
    private let storyboard = Storyboard.authorization

    // MARK: - Coordinator
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        goToSignIn()
    }
}

// MARK: - Navigation
extension SignInCoordinator {
        
    private func goToSignIn() {
        let vc = storyboard.controller(of: SignInVC.self)
        let vm = SignInVM(coordintaor: self)
        vc.viewModel = vm
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func showSignUpAlert(handler: @escaping (_ userName: String?) -> ()) {
        AlertHelper.showAlertWithTextField(with: "Registration", and: "Enter user name", in: navigationController, completion: handler)
    }
    
    private func showAuthErrorAlert(with message: String) {
        AlertHelper.showAlert(with: "Error", and: message, in: navigationController)
    }
}

// MARK: - SignInViewModelCoordinatorDelegate subscription
extension SignInCoordinator: SignInViewModelCoordinatorDelegate {
    
    func didLogin() {
        delegate?.userDidLogin(coordinator: self)
    }
    
    func startSignUp(handler: @escaping (_ userName: String?) -> ()) {
        showSignUpAlert(handler: handler)
    }
    
    func AuthError(with message: String) {
        showAuthErrorAlert(with: message)
    }
}
