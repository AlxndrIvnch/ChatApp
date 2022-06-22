//
//  UIStoryboard.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import Foundation
import UIKit

extension UIStoryboard {
    func controller<T: UIViewController>(of type: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: type.self)) as! T
    }
}
