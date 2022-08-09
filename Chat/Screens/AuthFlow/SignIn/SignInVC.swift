//
//  SignInVC.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import UIKit

class SignInVC: UIViewController {

    // MARK: - Properties
    var viewModel: SignInViewModelType?
    
    // MARK: - Outlets
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup
    func setup() {
        startButton.isEnabled = false
        
        loginTextField.addTarget(self, action: #selector(startEnteringName), for: .editingChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: - Action's
    @objc private func addButtonTapped() {
        viewModel?.startSignUp()
    }
    
    @objc private func startEnteringName() {
        let text = loginTextField.text
        startButton.isEnabled = !(text ?? "").isEmpty
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        let text = loginTextField.text ?? ""
        viewModel?.startSignIn(with: text)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}
