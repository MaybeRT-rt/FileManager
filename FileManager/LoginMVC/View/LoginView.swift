//
//  LoginView.swift
//  FileManager
//
//  Created by Liz-Mary on 08.09.2023.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    let passwordTextField: UITextField = {
        let passwdTF = UITextField()
        passwdTF.translatesAutoresizingMaskIntoConstraints = false
        passwdTF.placeholder = "Введите пароль"
        passwdTF.isSecureTextEntry = true
        return passwdTF
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Ввести пароль", for: .normal)
        button.backgroundColor = .systemMint
        return button
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(stackView)
        stackView.addSubview(passwordTextField)
        stackView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
            passwordTextField.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            
            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -20),
            actionButton.widthAnchor.constraint(equalToConstant: 50),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
