//
//  ViewState.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/24.
//

enum ViewState<T> {
    case idle
    case loading
    case loaded(T)
    case failed(String)
}
