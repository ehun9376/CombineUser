//
//  ViewState.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

enum ViewState {
    case idle
    case loading
    case loaded(Any)
    case failed(String)
}
