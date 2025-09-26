//
//  OverlayWindowAlertPresenter.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/26.
//

import UIKit

class AlertPresenter: AlertPresenting {
    
    static let shared = AlertPresenter()
    
    private weak var window: UIWindow?
    
    func setup(window: UIWindow?) {
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


