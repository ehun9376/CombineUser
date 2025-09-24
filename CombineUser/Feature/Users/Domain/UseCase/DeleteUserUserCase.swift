//
//  FetchUsersUseCase.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine

class DeleteUserUseCase {
    
    private let repository: UsersRepository
    
    init(
        repository: UsersRepository
    ) {
        self.repository = repository
    }

    func execute(by id: Int) -> AnyPublisher<Bool, DomainError> {
        return self.repository.deleteUser(id: id)
    }
}

