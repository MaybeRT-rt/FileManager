//
//  ExtensionLoginVC.swift
//  FileManager
//
//  Created by Liz-Mary on 11.09.2023.
//

import Foundation

extension LoginController {
    
    func updateButtonText() {
        if passwordModel.isCreatingPassword {
            loginView.actionButton.setTitle("Создать пароль", for: .normal)
            loginView.actionButton.addTarget(self, action: #selector(createPasswordButtonTapped), for: .touchUpInside)
        } else {
            loginView.actionButton.setTitle("Введите пароль", for: .normal)
            loginView.actionButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
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
        if passwordModel.isCreatingPassword {
            if let password = loginView.passwordTextField.text, password.count >= 4 {
                if isCreatingPassword {
                    // Это второй раз ввод пароля, сравниваем с первым вводом
                    if password == confirmedPassword {
                        passwordModel.savePassword(confirmedPassword) // Сохраняем подтвержденный пароль
                        let tabBarController = TabBarController()
                        navigationController?.setViewControllers([tabBarController], animated: true)
                        delegate?.loginControllerDidFinishChangingPassword()
                    } else {
                        self.view.makeToast("Пароли не совпадают")
                        // Сбросить поля пароля и запросить ввод еще раз
                        loginView.passwordTextField.text = ""
                        confirmedPassword = ""
                        updateButtonText()
                        isCreatingPassword = false
                    }
                } else {
                    // Первый раз ввод пароля
                    confirmedPassword = password
                    loginView.passwordTextField.text = ""
                    loginView.actionButton.setTitle("Повторите пароль", for: .normal)
                    isCreatingPassword = true
                }
            } else {
                self.view.makeToast("Пароль не соответсвует требованиям")
            }
        }
    }
}
