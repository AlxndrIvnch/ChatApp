//
//  SignInVM.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import Foundation
import ARSLineProgress

protocol SignInViewModelType {

    func startSignIn(with name: String)
    
    func startSignUp()
    
}

protocol SignInViewModelCoordinatorDelegate: AnyObject {
 
    func startSignUp(handler: @escaping (_ userName: String?) -> ())
    
    func AuthError(with message: String)
    
    func didLogin()
}

class SignInVM {
    
    // MARK: - Properties
    private var registerModel: UserModel?
    private weak var coordinatorDelegate: SignInViewModelCoordinatorDelegate!

    // MARK: - Init
    init(coordintaor: SignInViewModelCoordinatorDelegate) {
        self.coordinatorDelegate = coordintaor
    }

    // MARK: - Network
    func signUp() {
        guard let model = registerModel else { return }
        
        ARSLineProgress.show()
        AuthManager.shared.signUp(with: model) { result in
            ARSLineProgress.hideWithCompletionBlock {
                switch result {
                case .error(let massage):
                    self.coordinatorDelegate.AuthError(with: massage.changed())
                case .success:
                    self.coordinatorDelegate.didLogin()
                }
            }
        }
    }
    
    func signIn() {
        guard let model = registerModel else { return }
        
        ARSLineProgress.show()
        AuthManager.shared.signIn(with: model) { result in
            ARSLineProgress.hideWithCompletionBlock {
                switch result {
                case .error(let massage):
                    self.coordinatorDelegate.AuthError(with: massage.changed())
                case .success:
                    self.coordinatorDelegate.didLogin()
                }
            }
        }
    }
}
	
extension SignInVM: SignInViewModelType {

        // MARK: - Events

    func startSignUp() {
        coordinatorDelegate.startSignUp { [weak self] userName in
            guard let self = self else { return }
            
            let name = userName ?? ""
            self.registerModel = UserModel(name: name)
            self.signUp()
        }
    }
    
    func startSignIn(with name: String) {
        registerModel = UserModel(name: name)
        signIn()
    }
}
