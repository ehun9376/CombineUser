//
//  UsersEndpoint.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Foundation

class UsersEndpoint {
    
    static func getUsers() -> Endpoint {
        let e = Endpoint(path: "/users", method: .get, query: nil, headers: nil, body: nil)
        return e
    }
    
    static func getUser(id: Int) -> Endpoint {
        let e = Endpoint(path: "/users/\(id)", method: .get, query: nil, headers: nil, body: nil)
        return e
    }
    

}

