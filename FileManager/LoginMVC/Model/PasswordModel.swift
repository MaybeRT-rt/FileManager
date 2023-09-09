//
//  PasswordModel.swift
//  FileManager
//
//  Created by Liz-Mary on 09.09.2023.
//

import Foundation
import KeychainAccess

class PasswordModel {
    
    static let shared = PasswordModel()
    private let keychain = Keychain(service: "com.yourapp.password")
    
    func savePassword(_ password: String) {
        keychain[string: "password"] = password
    }
    
    func getPassword() -> String? {
        return keychain[string: "password"]
    }
    
    func validatePassword(_ inputPassword: String) -> Bool {
        if let savedPassword = getPassword() {
            return inputPassword == savedPassword
        }
        return false
    }
}
