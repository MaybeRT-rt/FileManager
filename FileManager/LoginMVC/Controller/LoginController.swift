//
//  LoginController.swift
//  FileManager
//
//  Created by Liz-Mary on 08.09.2023.
//

import Foundation
import UIKit
import Toast

class LoginController: UIViewController {
    
    weak var delegate: LoginControllerDelegate?
    
    private let loginView = LoginView()
    private let loginModel = LoginModel()
    private let passwordModel = PasswordModel.shared
    
    var isCreatingPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        testPass()
    }
    
    func testPass() {
        if passwordModel.getPassword() != nil {
            isCreatingPassword = false
        } else {
            isCreatingPassword = true
        }
        
        updateButtonText()
    }
        
    private func setupView() {
        view.addSubview(loginView.label)
        view.addSubview(loginView.stackView)
        
        NSLayoutConstraint.activate([
            
            loginView.label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            loginView.label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            loginView.stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loginView.stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loginView.stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            loginView.stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateButtonText() {
        if PasswordManager.shared.isPasswordCreationEnabled() {
            loginView.actionButton.setTitle("Создать пароль", for: .normal)
            loginView.actionButton.addTarget(self, action: #selector(createPasswordButtonTapped), for: .touchUpInside)
        } else {
            loginView.actionButton.setTitle("Введите пароль", for: .normal)
            loginView.actionButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc private func saveNewPasswordButtonTapped() {
        if let newPassword = loginView.passwordTextField.text, newPassword.count >= 4 {
            passwordModel.savePassword(newPassword)
            isCreatingPassword = false
            updateButtonText()
            delegate?.loginControllerDidFinishChangingPassword()
        } else {
            self.view.makeToast("Новый пароль не удовлетворяет требованиям (например, меньше 4 символов)")
        }
    }
    
    @objc private func loginButtonTapped() {
        let enteredPassword = loginView.passwordTextField.text ?? ""
        if passwordModel.validatePassword(enteredPassword) {
            let tabBarController = TabBarController()
            navigationController?.setViewControllers([tabBarController], animated: true)
            delegate?.loginControllerDidFinishChangingPassword()
        } else {
            self.view.makeToast("Введен неверный пароль")
        }
    }
    
    @objc private func createPasswordButtonTapped() {
        if isCreatingPassword {
            if let password = loginView.passwordTextField.text, password.count >= 4 {
                passwordModel.savePassword(password)
                let tabBarController = TabBarController()
                navigationController?.setViewControllers([tabBarController], animated: true)
                delegate?.loginControllerDidFinishChangingPassword()
            } else {
                self.view.makeToast("Пароль не соответсвует требованиям")
            }
        } else {
            // Первый раз ввод пароля
            loginView.passwordTextField.text = ""
            loginView.actionButton.setTitle("Повторите пароль", for: .normal)
            isCreatingPassword = true
        }
    }
}

