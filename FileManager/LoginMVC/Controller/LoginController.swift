//
//  LoginController.swift
//  FileManager
//
//  Created by Liz-Mary on 08.09.2023.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    
    weak var delegate: LoginControllerDelegate?
    
    private let loginView = LoginView()
    private let loginModel = LoginModel()
    private let passwordModel = PasswordModel.shared
    
    private var isCreatingPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        updateButtonText()
    }
    
    private func setupView() {
        view.addSubview(loginView.stackView)
        
        NSLayoutConstraint.activate([
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
        } else {
            print("Новый пароль не удовлетворяет требованиям (например, меньше 4 символов)")
        }
    }
    
    @objc private func loginButtonTapped() {
        let enteredPassword = loginView.passwordTextField.text ?? ""
        
        if passwordModel.validatePassword(enteredPassword) {
            let tabBarController = TabBarController()
            navigationController?.setViewControllers([tabBarController], animated: true)
        } else {
            print("Введен неверный пароль")
            // кейс с созданием нового пароля если забыл старый
        }
    }
    
    @objc private func createPasswordButtonTapped() {
        if isCreatingPassword {
            if let password = loginView.passwordTextField.text, password.count >= 4 {
                passwordModel.savePassword(password)
                delegate?.loginControllerDidFinishChangingPassword()
                dismiss(animated: true, completion: nil)
            } else {
                print("пароль не совпадает или меньше 4 символов")
            }
        } else {
            loginView.passwordTextField.text = ""
            loginView.actionButton.setTitle("Повторите пароль", for: .normal)
            isCreatingPassword = true
        }
    }
}
