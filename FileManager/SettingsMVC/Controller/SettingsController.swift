//
//  SettingsController.swift
//  FileManager
//
//  Created by Liz-Mary on 09.09.2023.
//

import Foundation
import UIKit

class SettingsController: UIViewController {
    
    private let settingsView = SettingsView()
    private let settingsModel = SettingsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //title = "Настройки"
        setupView()
    }
    
    private func setupView() {
        view.addSubview(settingsView)
        
        NSLayoutConstraint.activate([
            settingsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        
        settingsView.tableView.delegate = self
        settingsView.tableView.dataSource = self
        settingsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsModel.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsModel.sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsModel.sections[section].options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let option = settingsModel.sections[indexPath.section].options[indexPath.row]
        cell.textLabel?.text = option.title
        cell.accessoryType = option.isSelected ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var option = settingsModel.sections[indexPath.section].options[indexPath.row]
        option.isSelected.toggle()
        tableView.reloadData()
        let defaults = UserDefaults.standard
        defaults.set(option.isSelected, forKey: "YourOptionKey")
        
    }
}
