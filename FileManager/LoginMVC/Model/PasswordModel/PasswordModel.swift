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
    
    var isCreatingPassword: Bool {
        get {
            return keychain[string: "isCreatingPassword"] == "true"
        }
        set {
            keychain[string: "isCreatingPassword"] = newValue ? "true" : "false"
        }
    }
    
    func savePassword(_ password: String?) {
        keychain[string: "password"] = password
    }
    
    func getPassword() -> String? {
        return keychain[string: "password"]
    }
    
    func startCreatingPassword() {
        isCreatingPassword = true
    }
    
    func validatePassword(_ inputPassword: String) -> Bool {
        if let savedPassword = getPassword() {
            return inputPassword == savedPassword
        }
        return false
    }
}
