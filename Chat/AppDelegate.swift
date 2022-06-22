//
//  AppDelegate.swift
//  Chat
//
//  Created by Aleksandr on 14.06.2022.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        FirebaseApp.configure()

        let window = UIWindow(frame: UIScreen.main.bounds) 

            coordinator = AppCoordinator(winidow: window)
            coordinator?.start()
        
        return true
    }

}

	
