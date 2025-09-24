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
        
        let jsonPlaceholder = APIURL.jsonPlaceholder
        let client = APIClient(baseURL: jsonPlaceholder.rawValue)
        let repo = UsersRepositoryImpl(api: client)
        let fetchUseCase = FetchUsersUseCase(repository: repo)
        let fetchByIdUseCase = FetchUsersByIdUseCase(repository: repo)
        let listVM = UsersListViewModel(fetchUsers: fetchUseCase, fetchUserById: fetchByIdUseCase)
        let listVC = UsersListViewController(viewModel: listVM)
        let nav = UINavigationController(rootViewController: listVC)


        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

        return true
    }

}

