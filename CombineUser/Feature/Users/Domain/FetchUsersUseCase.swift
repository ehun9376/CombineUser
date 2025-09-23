//
//  FetchUsersUseCase.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine

class FetchUsersUseCase {
    
    private let repository: UsersRepository
    
    init(
        repository: UsersRepository
    ) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[User], DomainError> {
        return self.repository.fetchUsers()
    }
}
