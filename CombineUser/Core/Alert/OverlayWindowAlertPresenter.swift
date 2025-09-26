//
//  OverlayWindowAlertPresenter.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/26.
//

import UIKit

class AlertPresenter {
    static var shared: OverlayWindowAlertPresenter!
    
    // 禁止直接初始化，強制使用 shared instance
    private init() {}
}

class OverlayWindowAlertPresenter: AlertPresenting {
    
    private weak var window: UIWindow?
    

    init(
        window: UIWindow? = nil
    ) {
        self.window = window
       
    }

    func showAlert(_ style: AlertStyle) {
        DispatchQueue.main.async {
            let alert = self.makeAlertVC(style)
            self.window?.rootViewController?.present(alert, animated: true)
        }
    }

    private func makeAlertVC(_ config: AlertStyle) -> UIViewController {
        switch config {
        case .simple(let config):
            let vc = AlertViewController(config: config,
                                         dismissOnBackgroundTap: config.prefersDismissOnBackgroundTap)
            return vc
        }
      
    }

}


