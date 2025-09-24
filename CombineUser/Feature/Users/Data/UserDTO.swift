//
//  UserDTO.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

import Foundation

struct UserDTO: Decodable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: AddressDTO
    let company: CompanyDTO

}


struct AddressDTO: Decodable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

struct CompanyDTO: Decodable {
    let name: String
    let catchPhrase: String
    let bs: String
}


