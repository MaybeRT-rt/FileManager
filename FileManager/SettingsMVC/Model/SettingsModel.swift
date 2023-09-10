//
//  SettingsModel.swift
//  FileManager
//
//  Created by Liz-Mary on 09.09.2023.
//

import Foundation

class SettingsModel {
    
    static let shared = SettingsModel()
    private let defaults = UserDefaults.standard
    
    private let sortingKey = "SortingKey"
    
    var isSortingEnabled: Bool {
        get {
            return defaults.bool(forKey: sortingKey)
        }
        set {
            defaults.set(newValue, forKey: sortingKey)
        }
    }
    
    init() {
        if defaults.object(forKey: sortingKey) == nil {
            defaults.set(true, forKey: sortingKey)
        }
    }
    
    func setSortingEnabled(_ isEnabled: Bool) {
        isSortingEnabled = isEnabled
    }
}
