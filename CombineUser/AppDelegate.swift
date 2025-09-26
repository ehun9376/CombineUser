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
    
    var appCoordinator: AppCoordinator?

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let navigationController = UINavigationController()
        self.appCoordinator = AppCoordinator(
            navigationController: navigationController,
            appContainer: AppContainer()
        )
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        self.appCoordinator?.start() // 只負責啟動
        
        return true
    }

}

