//
//  APIClient.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Foundation
import Combine

class APIClient {
    
    private let session: URLSession
    private let baseURL: String
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    init(
        baseURL: String,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, type: T.Type, policy: RetryPolicy = .networkAnd5xx) -> AnyPublisher<T, APIError> {
        do {
            guard let url = URL(string: self.baseURL) else {
                throw APIError.invalidURL
            }
            var comps = URLComponents(url: url.appendingPathComponent(endpoint.path),
                                      resolvingAgainstBaseURL: false)
            
            comps?.queryItems = endpoint.query
            
            guard let url = comps?.url else {
                throw APIError.invalidURL
            }
            
            var request = URLRequest(url: url)
            
            request.httpMethod = endpoint.method.rawValue.uppercased()
            
            endpoint.headers?.forEach {
                request.setValue($1, forHTTPHeaderField: $0)
            }
            
            if let body = endpoint.body {
                request.httpBody = try self.encoder.encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            return self.session.dataTaskPublisher(for: request)
                .tryMap { output in
                    guard let http = output.response as? HTTPURLResponse else {
                        throw APIError.unknown
                    }
                    guard (200...299).contains(http.statusCode) else {
                        throw APIError.server(status: http.statusCode)
                    }
                    return output.data
                }
                .mapError { error in
                    if let apiError = error as? APIError {
                        return apiError
                    } else {
                        return APIError.transport(error)
                    }
                }
                .decode(type: T.self, decoder: self.decoder)
                .mapError { error in
                    if let apiError = error as? APIError {
                        return apiError
                    } else {
                        return APIError.decoding(error)
                    }
                }
                .retry(policy: policy)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error as? APIError ?? .unknown).eraseToAnyPublisher()
        }
    }
}
