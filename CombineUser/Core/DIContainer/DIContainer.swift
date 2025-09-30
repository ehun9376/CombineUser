//
//  DIContainer.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/25.
//

import UIKit
protocol Resolver {
    func resolve<T>() -> T
}

class AppContainer: Resolver, ObservableObject {
    
    private var singletons: [ObjectIdentifier: Any] = [:]
    
    init() {
        singletons[ObjectIdentifier(APIClient.self)] = APIClient(baseURL: APIURL.jsonPlaceholder.rawValue)
    }
    
    func resolve<T>() -> T {
        let key = ObjectIdentifier(T.self)
        guard let v = singletons[key] as? T else {
            fatalError("Unregistered \(T.self)")
        }
        return v
    }
    
}

class UsersContainer: Resolver {
        
    private let parent: Resolver
    
    private var factories: [ObjectIdentifier: (UsersContainer) -> Any] = [:]

    init(parent: Resolver) {
        self.parent = parent
        
        self.factories[ObjectIdentifier((any UsersRepository).self)] = { c in
            UsersRepositoryImpl(api: c.parent.resolve())
        }
        
        self.factories[ObjectIdentifier(FetchUsersUseCase.self)] = { c in
            FetchUsersUseCase(repository: c.resolve())
        }
        
        self.factories[ObjectIdentifier(UsersListViewModel.self)] = { c in
            UsersListViewModel(fetchUsers: c.resolve())
        }
        
        self.factories[ObjectIdentifier(FetchUsersByIdUseCase.self)] = { c in
            FetchUsersByIdUseCase(repository: c.resolve())
        }
    }

    func resolve<T>() -> T {
        let key = ObjectIdentifier(T.self)
        if let f = factories[key], let v = f(self) as? T {
            return v
        }
        return parent.resolve()
    }
}
