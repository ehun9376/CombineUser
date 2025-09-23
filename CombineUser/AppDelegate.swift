//
//  AppDelegate.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let jsonPlaceholder = APIDomain.jsonPlaceholder
        let client = APIClient(baseURL: jsonPlaceholder.rawValue)
        let repo = UsersRepositoryImpl(api: client)
        let useCase = FetchUsersUseCase(repository: repo)
        let listVM = UsersListViewModel(fetchUsers: useCase)
        let listVC = UsersListViewController(viewModel: listVM)
        let nav = UINavigationController(rootViewController: listVC)


        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

        return true
    }

}

