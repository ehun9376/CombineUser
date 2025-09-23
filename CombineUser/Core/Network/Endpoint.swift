//
//  Endpoint.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}

class Endpoint {
    var path: String
    var method: HTTPMethod
    var query: [URLQueryItem]?
    var headers: [String: String]?
    var body: [String: String]?
    
    init(path: String, method: HTTPMethod, query: [URLQueryItem]? = nil, headers: [String : String]? = nil, body: [String : String]? = nil) {
        self.path = path
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
    }
}
