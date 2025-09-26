//
//  AlertViewController.swift
//  CombineUser
//
//  Created by 陳逸煌 on 2025/9/26.
//

import UIKit

class AlertViewController: UIViewController {
    
    private var config: SimpleAlertConfig?
    private var dismissOnBackgroundTap: Bool = false
    
    
    init(
        config: SimpleAlertConfig,
        dismissOnBackgroundTap: Bool
    ) {
        self.config = config
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAlert(config: self.config)
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        if self.dismissOnBackgroundTap {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
            self.view.addGestureRecognizer(tapGesture)
        }
    }

    func setupAlert(config: SimpleAlertConfig?) {
        guard let config = config else { return }
        
        
        // 創建主容器
        let alertView = UIView()
        alertView.backgroundColor = .systemBackground
        alertView.layer.cornerRadius = 14
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 0, height: 4)
        alertView.layer.shadowRadius = 16
        alertView.layer.shadowOpacity = 0.1
        alertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertView)
        
        // 垂直 StackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(stackView)
        
        // 標題
        if let title = config.title, !title.isEmpty {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            titleLabel.textColor = .label
            
            let titleContainer = UIView()
            titleContainer.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor, constant: 20),
                titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor, constant: 16),
                titleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor, constant: -16),
                titleLabel.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor, constant: config.message != nil ? -4 : -20)
            ])
            
            stackView.addArrangedSubview(titleContainer)
        }
        
        // 訊息
        if let message = config.message, !message.isEmpty {
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = UIFont.systemFont(ofSize: 13)
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.textColor = .secondaryLabel
            
            let messageContainer = UIView()
            messageContainer.addSubview(messageLabel)
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let topPadding: CGFloat = config.title != nil ? 4 : 20
            
            NSLayoutConstraint.activate([
                messageLabel.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: topPadding),
                messageLabel.leadingAnchor.constraint(equalTo: messageContainer.leadingAnchor, constant: 16),
                messageLabel.trailingAnchor.constraint(equalTo: messageContainer.trailingAnchor, constant: -16),
                messageLabel.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -20)
            ])
            
            stackView.addArrangedSubview(messageContainer)
        }
        
        // 按鈕區域
        if !config.actions.isEmpty {
            // 分隔線
            let separator = UIView()
            separator.backgroundColor = .separator
            separator.translatesAutoresizingMaskIntoConstraints = false
            separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            stackView.addArrangedSubview(separator)
            
            if config.actions.count == 1 {
                // 單個按鈕：全寬
                let action = config.actions[0]
                let button = createActionButton(for: action)
                button.heightAnchor.constraint(equalToConstant: 44).isActive = true
                stackView.addArrangedSubview(button)
            } else if config.actions.count == 2 {
                // 兩個按鈕：並排
                let buttonContainer = UIView()
                buttonContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
                
                let leftAction = config.actions[0]
                let rightAction = config.actions[1]
                
                let leftButton = createActionButton(for: leftAction)
                let rightButton = createActionButton(for: rightAction)
                
                buttonContainer.addSubview(leftButton)
                buttonContainer.addSubview(rightButton)
                
                // 中間分隔線
                let verticalSeparator = UIView()
                verticalSeparator.backgroundColor = .separator
                verticalSeparator.translatesAutoresizingMaskIntoConstraints = false
                buttonContainer.addSubview(verticalSeparator)
                
                leftButton.translatesAutoresizingMaskIntoConstraints = false
                rightButton.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    // 左按鈕
                    leftButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
                    leftButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor),
                    leftButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
                    leftButton.trailingAnchor.constraint(equalTo: verticalSeparator.leadingAnchor),
                    
                    // 分隔線
                    verticalSeparator.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
                    verticalSeparator.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
                    verticalSeparator.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
                    verticalSeparator.widthAnchor.constraint(equalToConstant: 0.5),
                    
                    // 右按鈕
                    rightButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
                    rightButton.leadingAnchor.constraint(equalTo: verticalSeparator.trailingAnchor),
                    rightButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor),
                    rightButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor)
                ])
                
                stackView.addArrangedSubview(buttonContainer)
            } else {
                // 多個按鈕：垂直排列
                for (index, action) in config.actions.enumerated() {
                    if index > 0 {
                        // 添加分隔線
                        let separator = UIView()
                        separator.backgroundColor = .separator
                        separator.translatesAutoresizingMaskIntoConstraints = false
                        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                        stackView.addArrangedSubview(separator)
                    }
                    
                    let button = createActionButton(for: action)
                    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
                    stackView.addArrangedSubview(button)
                }
            }
        }
        
        // 設置約束
        NSLayoutConstraint.activate([
            // Alert 容器約束
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 270),
            
            // StackView 約束
            stackView.topAnchor.constraint(equalTo: alertView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor)
        ])
    }

    private func createActionButton(for action: AlertAction) -> UIButton {
        let button = SimpleButton(type: .system)
        button.setTitle(action.title, for: .normal)
        button.setTitleColor(action.color, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = action.font
        button.setActionClosure({ [weak self] in
            guard let self = self else { return }
            action.handler?()
            self.dismissAlert()
        })

        
        return button
    }



  
    
}
