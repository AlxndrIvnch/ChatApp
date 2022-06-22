//
//  AlertHelper.swift
//  Chat
//
//  Created by Aleksandr on 17.06.2022.
//

import Foundation
import UIKit

class AlertHelper {
    
    static func showAlert(with title: String, and message: String? = nil, in controller: UIViewController) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        ac.addAction(okAction)
        controller.present(ac, animated: true)
    }
    
    static func showAlertWithTextField(with title: String, and message: String? = nil, in controller: UIViewController, completion: @escaping ItemClosure<String?>) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addTextField()
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            let text = ac.textFields?.first?.text
            completion(text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        controller.present(ac, animated: true)
    }
    
}
