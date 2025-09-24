//
//  UsersRepository.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Combine

protocol UsersRepository {
    func fetchUsers() -> AnyPublisher<[User], DomainError>
    func fetchUser(by id: Int) -> AnyPublisher<User, DomainError>
    func deleteUser(id: Int) -> AnyPublisher<Bool, DomainError>
}
