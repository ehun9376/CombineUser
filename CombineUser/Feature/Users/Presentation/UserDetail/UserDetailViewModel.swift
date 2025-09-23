//
//  UserDetailViewModel.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

final class UserDetailViewModel {
    let title: String
    let lines: [(String, String)]

    init(title: String, lines: [(String, String)]) {
        self.title = title
        self.lines = lines
    }
}
