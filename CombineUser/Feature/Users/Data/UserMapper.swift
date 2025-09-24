//
//  UserMapper.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

extension UserDTO {
    func toDomain() -> User {
        User(
            id: self.id,
            name: self.name,
            username: self.username,
            email: self.email,
            phone: self.phone,
            website: self.website,
            address: .init(street: self.address.street, suite: self.address.suite, city: self.address.city, zipcode: self.address.zipcode),
            company: .init(name: self.company.name, catchPhrase: self.company.catchPhrase, bs: self.company.bs)
        )
    }
}
