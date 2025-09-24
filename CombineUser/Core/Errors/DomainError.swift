//
//  DomainError.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//


enum DomainError: Error {
    case network
    case server
    case decoding
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .network: return "Network error."
        case .server: return "Server error."
        case .decoding: return "Decoding error."
        case .unknown: return "Unknown error."
        }
    }
    
    static func from(apiError: APIError) -> DomainError {
        switch apiError {
        case .invalidURL, .transport: return .network
        case .server: return .server
        case .decoding: return .decoding
        case .unknown: return .unknown
        }
    }
}
