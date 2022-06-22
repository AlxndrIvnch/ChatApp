//
//  UsersListVC.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import UIKit

class UsersListVC: UIViewController {

    // MARK: - Properties
    var viewModel: UsersListViewModelType? {
        didSet {
            viewModel?.viewDelegate = self
         }
    }

    @IBOutlet weak var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        delegating()
        registerCells()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        title = "Chats"
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.startUpdatingUsers()
        viewModel?.startUpdatingChatsActions()

    }
    
    func delegating() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
    }
    
    func registerCells() {
        usersTableView.register(UserTableViewCell.nib(), forCellReuseIdentifier: UserTableViewCell.nibName())
    }
    
    @objc func logoutButtonTapped() {
        viewModel?.logoutButtonTapped()
    }
}

extension UsersListVC: UsersListViewModelViewDelegate {
    
    func updateTable() {
        usersTableView.reloadData()
    }
    
}

extension UsersListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.nibName(), for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        guard let user = viewModel?.getUser(for: indexPath.row) else { return UITableViewCell() }
        guard let count = viewModel?.getUnreadCount(for: indexPath.row) else { return UITableViewCell() }
        
        cell.configure(by: user, and: count)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.rowTapped(indexPath.row)
    }
}

extension UsersListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberOfRows() ?? 0
    }
}
