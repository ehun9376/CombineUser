//
//  DeleteUserUseCase.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import Combine

class DeleteUserUseCase {
    
    private let repository: UsersRepository
    
    init(repository: UsersRepository) {
        self.repository = repository
    }
    
    func execute(userId: Int) -> AnyPublisher<Void, DomainError> {
        return repository.deleteUser(id: userId)
    }
}
