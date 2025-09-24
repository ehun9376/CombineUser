//
//  FetchUserDetailUseCase.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import Combine

class FetchUserDetailUseCase {
    
    private let repository: UsersRepository
    
    init(repository: UsersRepository) {
        self.repository = repository
    }
    
    func execute(userId: Int) -> AnyPublisher<User, DomainError> {
        return repository.fetchUser(by: userId)
    }
}
