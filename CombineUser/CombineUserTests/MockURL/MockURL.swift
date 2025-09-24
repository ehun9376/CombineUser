//
//  MockURLProtocol.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import Foundation
import XCTest
import Combine
@testable import CombineUser


class MockURL: URLProtocol {
    static var response: (Int, Data) = (200, Data())
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        let (status, data) = Self.response
        let http = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: http, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}


