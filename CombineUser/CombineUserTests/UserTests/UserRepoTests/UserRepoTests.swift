//
//  UserRepoTests.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import XCTest
import Combine
@testable import CombineUser

class UserRepoTests: XCTestCase {
    
    func makeAPIClient() -> APIClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURL.self]
        let session = URLSession(configuration: config)
        return APIClient(baseURL: APIURL.jsonPlaceholder.rawValue, session: session)
    }
    
    
    func test_repository_success_decodesAndMaps() {
        let json = """
        [{"id":1,"name":"A","username":"a","email":"a@a.com","phone":"1","website":"w",
          "address":{"street":"s","suite":"1","city":"c","zipcode":"z"},
          "company":{"name":"co","catchPhrase":"cp","bs":"bs"}}]
        """.data(using: .utf8)!
        MockURL.response = (200, json)

        let api = self.makeAPIClient()
        let repo = UsersRepositoryImpl(api: api)

        let exp = expectation(description: "ok")
        var bag = Set<AnyCancellable>()

        repo.fetchUsers()
            .sink(
                receiveCompletion: { c in
                    if case .failure(let e) = c {
                        XCTFail("\(e)")
                    }
                },
                receiveValue: { users in
                    XCTAssertEqual(users.count, 1)
                    XCTAssertEqual(users[0].name, "A")
                    exp.fulfill()
                }
            ).store(in: &bag)
        
        wait(for: [exp], timeout: 1)
    }

    func test_repository_http_404_mapsToServerError() {
        MockURL.response = (404, Data())

        let api = self.makeAPIClient()
        let repo = UsersRepositoryImpl(api: api)

        let exp = expectation(description: "err")
        var bag = Set<AnyCancellable>()

        repo.fetchUsers()
            .sink(
                receiveCompletion: { c in
                    if case .failure(let e) = c {
                        XCTAssertEqual(e, .server)
                        exp.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail("should fail")
                }
            )
            .store(in: &bag)

        wait(for: [exp], timeout: 1)
    }
    
    func test_repository_success_decodes() {
        let json = """
        {"id":1,"name":"A","username":"a","email":"a@a.com","phone":"1","website":"w",
          "address":{"street":"s","suite":"1","city":"c","zipcode":"z"},
          "company":{"name":"co","catchPhrase":"cp","bs":"bs"}}
        """.data(using: .utf8)!
        MockURL.response = (200, json)

        let api = self.makeAPIClient()
        let repo = UsersRepositoryImpl(api: api)

        let exp = expectation(description: "ok")
        var bag = Set<AnyCancellable>()

        repo.fetchUser(by: 1)
            .sink(
                receiveCompletion: { c in
                    if case .failure(let e) = c {
                        XCTFail("\(e)")
                    }
                },
                receiveValue: { users in
                    XCTAssertEqual(users.name, "A")
                    exp.fulfill()
                }
            ).store(in: &bag)
        
        wait(for: [exp], timeout: 1)
    }
    

 

}

