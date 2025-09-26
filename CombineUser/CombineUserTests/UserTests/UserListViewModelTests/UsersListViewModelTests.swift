//
//  UsersListViewModelTests.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/26.
//

import XCTest
import Combine
@testable import CombineUser

class UsersListViewModelTests: XCTestCase {
    
    var sut: UsersListViewModelProtocol!
    
    class UsersRepositoryMock: UsersRepository {
        func fetchUsers() -> AnyPublisher<[User], DomainError> {
            return Just([])
                .setFailureType(to: DomainError.self)
                .eraseToAnyPublisher()
                
        }
        
        func fetchUser(by id: Int) -> AnyPublisher<User, DomainError> {
            return Just(User(id: 1, name: "", username: "", email: "", phone: "", website: "", address: .init(street: "", suite: "", city: "", zipcode: ""), company: .init(name: "", catchPhrase: "", bs: "")))
                .setFailureType(to: DomainError.self)
                .eraseToAnyPublisher()
        }
                        
                
    }
    
    override func setUp() {
        self.sut = UsersListViewModel(fetchUsers: FetchUsersUseCase(repository: UsersRepositoryImpl(api: APIClient(baseURL: APIURL.jsonPlaceholder.rawValue))))
        super.setUp()
    }
    
    override func tearDown() {
        self.sut = nil
        super.tearDown()
    }
    
    func test_init_state_is_idle() {
        
        switch sut.state {
        case .idle:
            XCTAssertTrue(true)
        default:
            XCTFail("初始狀態應為 idle")
        }
        
    }
    
    func test_load_state_is_loading() {
        self.sut.load(page: 1, size: 10)
        switch sut.state {
        case .loading:
            XCTAssertTrue(true)
        default:
            XCTFail("初始狀態應為 idle")
        }
    }
    
    func test_loaded_state_is_loaded() async {
        self.sut.load(page: 1, size: 10)
        try? await Task.sleep(for: .seconds(2))
        switch sut.state {
        case .loaded, .failed(_):
            XCTAssertTrue(true)
        default:
            XCTFail("loading完後應為 loaded")
        }
        
    }
    
    func test_loaded_success_users_count_is_10() async {
        self.sut.load(page: 1, size: 10)
        try? await Task.sleep(for: .seconds(2))
        switch sut.state {
        case .loaded:
            XCTAssertEqual(self.sut.users.count, 10)
        default:
            XCTFail("loading完後應為 loaded")
        }
        
    }
    
    func test_load_two_times_success_users_count_is_20() async {
        self.sut.load(page: 1, size: 10)
        self.sut.load(page: 2, size: 10)
        try? await Task.sleep(for: .seconds(2))
        switch sut.state {
        case .loaded:
            XCTAssertEqual(self.sut.users.count, 20)
        default:
            XCTFail("loading完後應為 loaded")
        }
        
    }
    
    func test_loaded_failed_state_is_failed() async {
        self.sut = UsersListViewModel(fetchUsers: FetchUsersUseCase(repository: UsersRepositoryMock()))
        self.sut.load(page: 1, size: 10)
        try? await Task.sleep(for: .seconds(2))
        switch sut.state {
        case .failed(_):
            XCTAssertTrue(true)
        default:
            XCTFail("沒資料時應為 failed")
        }
    }
    
    
    
    
}
