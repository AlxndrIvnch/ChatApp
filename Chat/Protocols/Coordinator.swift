//
//  Coordinator.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {

    var childCoordinators: [Coordinator] { get set }
    
    func start()

}

extension Coordinator {
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
