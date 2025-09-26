//
//  Coordinator.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    private let appContainer: AppContainer
    
    init(navigationController: UINavigationController, appContainer: AppContainer) {
        self.navigationController = navigationController
        self.appContainer = appContainer
    }
    
    func start() {
        let usersCoordinator = UsersCoordinator(
            navigationController: self.navigationController,
            appContainer: self.appContainer
        )
        childCoordinators.append(usersCoordinator)
        usersCoordinator.start()
    }
}

class UsersCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    private let appContainer: AppContainer
    
    init(navigationController: UINavigationController, appContainer: AppContainer) {
        self.navigationController = navigationController
        self.appContainer = appContainer
    }
    
    func start() {
        self.showUsersList()
    }
    
    func showUsersList() {
        let userContainer = UsersContainer(parent: self.appContainer)
        let viewModel = userContainer.resolve() as UsersListViewModel
        let viewController = UsersListViewController(viewModel: viewModel)
        viewController.coordinator = self
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    func showUserDetail(userId: Int) {
        let userContainer = UsersContainer(parent: self.appContainer)
        let viewModel = UserDetailViewModel(fetchUserById: userContainer.resolve(), userId: userId)
        let viewController = UserDetailViewController(viewModel: viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
