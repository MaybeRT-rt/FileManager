//
//  SettingsModel.swift
//  FileManager
//
//  Created by Liz-Mary on 09.09.2023.
//

import Foundation

struct SettingsSection {
    let title: String
    var options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    var isSelected: Bool
}

class SettingsModel {
    var sections: [SettingsSection] = [SettingsSection(title: "Сортировка", options: [
                SettingsOption(title: "По алфавиту", isSelected: true),
                SettingsOption(title: "Обратный порядок", isSelected: false)])]
}
