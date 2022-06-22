//
//  ChatVC.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import UIKit

class ChatVC: UIViewController {

    // MARK: - Properties
    var viewModel: ChatViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
         }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    override func loadView() {
        super.loadView()
        view.keyboardLayoutGuide.topAnchor.constraint(equalToSystemSpacingBelow: bottomView.bottomAnchor, multiplier: 1.0).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        delegating()
        registerCells()
        viewModel?.startLoadingMessages()
        setup()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.backButtonTapped()
    }
    
    func setup() {
        chatTableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        chatTableView.separatorColor = .clear
        
        sendButton.isEnabled = false
        
        title = viewModel?.getOpponentName()
        
        messageTextField.addTarget(self, action: #selector(startEnteringMessage), for: .editingChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func delegating() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
    }
    
    func registerCells() {
        chatTableView.register(MessageTableViewCell.nib(isOpponent: false), forCellReuseIdentifier: MessageTableViewCell.nibName(isOpponent: false))
        chatTableView.register(MessageTableViewCell.nib(isOpponent: true), forCellReuseIdentifier: MessageTableViewCell.nibName(isOpponent: true))
    }
    
        // MARK: - Action's

    @IBAction func sendButtonTapped(_ sender: Any) {
        
        let text = messageTextField.text
        
        viewModel?.sendButtonTapped(with: text)
        
        messageTextField.text?.removeAll()
        sendButton.isEnabled = false
        
    }
    
    @objc private func startEnteringMessage() {
        guard let text = messageTextField.text else { return }
        sendButton.isEnabled = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }  

}

extension ChatVC: ChatViewModelViewDelegate {
    
    func updateTable() {
        chatTableView.reloadData()
    }
    
    func scrollToRow(_ row: Int, animated: Bool) {
        let indexPath = IndexPath(row: row, section: 0)
        chatTableView.scrollToRow(at: indexPath, at: .none, animated: animated)
    }
    
}

extension ChatVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let message = viewModel?.getMessage(for: indexPath.row) else { return UITableViewCell() }
        
        let identifier = MessageTableViewCell.nibName(isOpponent: message.isSenderOpponent)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        cell.configure(by: message)
        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let visibleRows = tableView.indexPathsForVisibleRows
        viewModel?.readMessages(with: visibleRows)
        
        let rowsCount = tableView.numberOfRows(inSection: 0)
        let row = indexPath.row
        
        guard row >= 20 else { return }
        
        if row >= rowsCount - 5 {
            viewModel?.configurePagination(with: .increase)
        }
        
        if row < rowsCount - 60 {
            viewModel?.configurePagination(with: .decrease)
        }
    }
    
}

extension ChatVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRows() ?? 0
    }

}

