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
        return self.api.request(UsersEndpoint.getUsers(), type: [UserDTO].self)
            .map({ $0.map { $0.toDomain() } })
            .mapError {
                DomainError.from(apiError: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func fetchUser(by id: Int) -> AnyPublisher<User, DomainError> {
        return self.api.request(UsersEndpoint.getUser(id: id), type: UserDTO.self)
            .map { $0.toDomain() }
            .mapError {
                DomainError.from(apiError: $0)
            }
            .eraseToAnyPublisher()
    }

    
}


