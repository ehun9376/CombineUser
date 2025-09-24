//
//  FetchUsersUseCase.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine

class FetchUsersByIdUseCase {
    
    private let repository: UsersRepository
    
    init(
        repository: UsersRepository
    ) {
        self.repository = repository
    }

    func execute(by id: Int) -> AnyPublisher<User, DomainError> {
        return self.repository.fetchUser(by: id)
    }
}

