//
//  AppDelegate.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var appContainer = AppContainer()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let userContainer = UsersContainer(parent: self.appContainer)
        let listVC = UsersListViewController(viewModel: userContainer.resolve())
        let nav = UINavigationController(rootViewController: listVC)


        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

        return true
    }

}

