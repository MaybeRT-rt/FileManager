//
//  PasswordManager.swift
//  FileManager
//
//  Created by Liz-Mary on 11.09.2023.
//

import Foundation

class PasswordManager {
    static let shared = PasswordManager()
    
    private var isCreatingPassword = false
    
    func startCreatingPassword() {
        isCreatingPassword = true
    }
    
    func stopCreatingPassword() {
        isCreatingPassword = false
    }
    
    func isPasswordCreationEnabled() -> Bool {
        return isCreatingPassword
    }
}
