//
//  LoginModel.swift
//  FileManager
//
//  Created by Liz-Mary on 08.09.2023.
//

import Foundation

class LoginModel {
    private let userDefaults = UserDefaults.standard
    
    var isPassword: Bool {
        return userDefaults.string(forKey: "password") != nil
    }
    
    func validatePassword(_ password: String) -> Bool {
        guard let savedPassword = userDefaults.string(forKey: "password") else {
            return false
        }
        return password == savedPassword
    }
}
