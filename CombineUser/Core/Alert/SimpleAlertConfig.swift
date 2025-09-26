//
//  Untitled.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/26.
//

import UIKit

enum AlertStyle {
    case simple(config: SimpleAlertConfig)
}

struct AlertAction {
    let title: String
    let font: UIFont
    let color: UIColor
    let handler: (() -> ())?
    
    static func cancel(title: String = "取消", handler: (() -> ())? = nil) -> AlertAction {
        return AlertAction(title: title, font: .systemFont(ofSize: 16), color: .gray, handler: handler)
    }
    
    static func confirm(title: String = "確認", handler: (() -> ())? = nil) -> AlertAction {
        return AlertAction(title: title, font: .boldSystemFont(ofSize: 16), color: .systemBlue, handler: handler)
    }
}

struct SimpleAlertConfig {
    let title: String?
    let message: String?
    let actions: [AlertAction]
    let prefersDismissOnBackgroundTap: Bool
}

protocol AlertPresenting {
    func showAlert(_ style: AlertStyle)
}
