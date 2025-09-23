//
//  UsersRepositoryImpl.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine

class UsersRepositoryImpl: UsersRepository {
    
    private let api: APIClient
    
    init(api: APIClient) { self.api = api }

    func fetchUsers() -> AnyPublisher<[User], DomainError> {
        return self.api.request(UsersEndpoint.getUsers(), type: [User].self)
            .mapError {
                DomainError.from(apiError: $0)
            }
            .eraseToAnyPublisher()
    }
}
