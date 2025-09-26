//
//  AlertStyle.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/26.
//

enum AlertStyle {
    case simple(config: SimpleAlertConfig)
}

protocol AlertPresenting {
    func showAlert(_ style: AlertStyle)
}
