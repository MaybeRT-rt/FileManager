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
    
    let loginView = LoginView()
    let loginModel = LoginModel()
    let passwordModel = PasswordModel.shared
    
    var isCreatingPassword = false
    var confirmedPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        testPass()
    }
    
    func testPass() {
        if passwordModel.getPassword() != nil {
            passwordModel.isCreatingPassword = false
        } else {
            passwordModel.startCreatingPassword()
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
}
