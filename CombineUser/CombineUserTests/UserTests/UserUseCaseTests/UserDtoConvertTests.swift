//
//  CombineUserTests.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/23.
//

import XCTest
import Combine
@testable import CombineUser

class UserDtoConvertTests: XCTestCase {
    
    ///確認DTO轉換成Domain的正確性
    func test_userDTO_toDomain_success() {
        let userDTO = UserDTO(id: 1, name: "A", username: "A", email: "email123@gmail.com", phone: "0987", website: "www.google.com.tw", address: .init(street: "street", suite: "suite", city: "city", zipcode: "zipcode"), company: .init(name: "111", catchPhrase: "catchPhrase", bs: "bs"))
        let user = userDTO.toDomain()
        
        XCTAssertEqual(user.name, "A")
    }

}
