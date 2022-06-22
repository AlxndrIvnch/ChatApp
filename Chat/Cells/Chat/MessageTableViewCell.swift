//
//  MessageTableViewCell.swift
//  Chat
//
//  Created by Aleksandr on 19.06.2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cloudView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cloudView.layer.cornerRadius = 10
    }
    
    func configure(by message: Message) {
        messageLabel.text = message.text
        timeLabel.text = message.getFormattedTime()  
    }
}

extension MessageTableViewCell {
    static func nibName(isOpponent: Bool) -> String {
        return isOpponent ? "OpponentMessageTableViewCell" :  "MyMessageTableViewCell"
    }
    
    static func nib(isOpponent: Bool) -> UINib {
        return UINib.init(nibName: nibName(isOpponent: isOpponent), bundle: Bundle.main)
    }
}
