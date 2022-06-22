//
//  UserTableViewCell.swift
//  Chat
//
//  Created by Aleksandr on 20.06.2022.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var unreadCountLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
     
        unreadCountLable.layer.masksToBounds = true
        unreadCountLable.layer.cornerRadius = 10
        
    }
    
    func configure(by user: UserModel, and unreadCount: Int) {

        nameLable.text = user.name
        if unreadCount > 0 {
            unreadCountLable.isHidden = false
            unreadCountLable.text = String(unreadCount)
        } else {
            unreadCountLable.isHidden = true
            unreadCountLable.text = ""
        }
    }
}

extension UserTableViewCell {
    
    static func nibName() -> String {
        return "UserTableViewCell"
    }
    
    static func nib() -> UINib {
        return UINib.init(nibName: nibName(), bundle: Bundle.main)
    }
}
