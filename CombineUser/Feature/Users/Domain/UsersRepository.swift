//
//  UsersRepository.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine

protocol UsersRepository {
    func fetchUsers() -> AnyPublisher<[User], DomainError>
}
