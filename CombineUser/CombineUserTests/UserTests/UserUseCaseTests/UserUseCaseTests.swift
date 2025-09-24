//
//  CombineUserTests.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/23.
//

import XCTest
import Combine
@testable import CombineUser

class UserUseCaseTests: XCTestCase {
    
    class UsersRepositoryMock: UsersRepository {
        
        var fetchUsersResult: AnyPublisher<[User], DomainError>!
        
        var fetchUserResult: AnyPublisher<User, DomainError>!
        
        var deleteResult: AnyPublisher<Bool, DomainError>!
            
                
        func fetchUsers() -> AnyPublisher<[User], DomainError> {
            return self.fetchUsersResult
        }
        
        func fetchUser(by id: Int) -> AnyPublisher<User, DomainError> {
                        
            return self.fetchUserResult
        }
        
        func deleteUser(id: Int) -> AnyPublisher<Bool, DomainError> {
            return self.deleteResult
        }
        
    }

    var bag = Set<AnyCancellable>()

    //MARK: -  測試UseCase的行為
    ///確認這個Usecase的行為是產出一個陣列
    func test_execute_success_returnUsers() {
        let repo = UsersRepositoryMock()
        repo.fetchUsersResult =
        Just([User(id: 1, name: "A", username: "A", email: "email123@gmail.com", phone: "0987", website: "www.google.com.tw", address: .init(street: "street", suite: "suite", city: "city", zipcode: "zipcode"), company: .init(name: "111", catchPhrase: "catchPhrase", bs: "bs"))])
            .setFailureType(to: DomainError.self)
            .eraseToAnyPublisher()

        let sut = FetchUsersUseCase(repository: repo)
        let exp = expectation(description: "users")
        
       
        sut.execute()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { users in
                    XCTAssertEqual(users.first?.name, "A")
                    exp.fulfill()
                }
            )
            .store(in: &bag)

        wait(for: [exp], timeout: 1)
    }
    
    ///確認這個Usecase的行為是失敗時會DomainError
    func test_execute_failure_propagatesDomainError() {
        let repo = UsersRepositoryMock()
        repo.fetchUsersResult = Fail(error: DomainError.network)
            .eraseToAnyPublisher()

        let sut = FetchUsersUseCase(repository: repo)
        let exp = expectation(description: "error")
        
        sut.execute()
            .sink(receiveCompletion: { c in
                if case .failure(let e) = c {
                    XCTAssertEqual(e, .network)
                    exp.fulfill()
                }
            },
                  receiveValue: { _ in
                XCTFail("Should not succeed")
            })
            .store(in: &bag)
        
        wait(for: [exp], timeout: 1)
    }
    
    ///確認這個Usecase的行為是產出一個UserModel
    func test_execute_success_returnUser() {
        let repo = UsersRepositoryMock()
        repo.fetchUserResult =
        Just(User(id: 1, name: "A", username: "A", email: "email123@gmail.com", phone: "0987", website: "www.google.com.tw", address: .init(street: "street", suite: "suite", city: "city", zipcode: "zipcode"), company: .init(name: "111", catchPhrase: "catchPhrase", bs: "bs")))
            .setFailureType(to: DomainError.self)
            .eraseToAnyPublisher()

        let sut = FetchUsersByIdUseCase(repository: repo)
        let exp = expectation(description: "user")
        
        //確認這個Usecase的行為是產出一個UserModel
        sut.execute(by: 1)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { users in
                    XCTAssertEqual(users.name, "A")
                    exp.fulfill()
                }
            )
            .store(in: &bag)

        wait(for: [exp], timeout: 1)
    }
    
    ///確認這個Usecase的行為是失敗時會DomainError
    func test_executeById_failure_propagatesDomainError() {
        let repo = UsersRepositoryMock()
        repo.fetchUserResult = Fail(error: DomainError.network)
            .eraseToAnyPublisher()
        
        let sut = FetchUsersByIdUseCase(repository: repo)
        let exp = expectation(description: "error")
        sut.execute(by: 1)
            .sink(receiveCompletion: { complete in
                if case .failure(let e) = complete {
                    XCTAssertEqual(e, .network)
                    exp.fulfill()
                }
                
            },
                  receiveValue: { _ in
                XCTFail("Should not succeed")
            })
            .store(in: &bag)
        wait(for: [exp], timeout: 1)
    }
    
    func test_deleteUser_success_returnTrue() {
        let repo = UsersRepositoryMock()
        repo.deleteResult = Just(true)
            .setFailureType(to: DomainError.self)
            .eraseToAnyPublisher()
        
        let sut = DeleteUserUseCase(repository: repo)
        
        let exp = expectation(description: "delete")
        sut.execute(by: 1)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { success in
                    XCTAssertTrue(success)
                    exp.fulfill()
                }
            )
            .store(in: &bag)
        wait(for: [exp], timeout: 1)
        
    }

}
