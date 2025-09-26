//
//  SimpleButton.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/26.
//

import UIKit


class SimpleButton: UIButton {
    
    private var actionClosure: (() -> Void)?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButton()
    }

    
    private func setupButton() {
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
       
    func setActionClosure(_ closure: (() -> Void)?) {
        self.actionClosure = closure
    }
    
    func performAction() {
        self.actionClosure?()
    }
    
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        guard let color = color else {
            setBackgroundImage(nil, for: state)
            return
        }
        
        let backgroundImage = createImageWithColor(color)
        setBackgroundImage(backgroundImage, for: state)
    }
    

    private func createImageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        
        color.setFill()
        UIRectFill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
    
    
    @objc private func buttonTapped() {
        self.actionClosure?()
    }
}
