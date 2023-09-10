//
//  SettingsController.swift
//  FileManager
//
//  Created by Liz-Mary on 09.09.2023.
//

import Foundation
import UIKit

class SettingsController: UIViewController, FileModelDelegate {
    
    private let settingsView = SettingsView()
    private let settingsModel = SettingsModel()
    private let fileModel = FileModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        
        fileModel.delegate = self
        
        settingsView.sortingSwitch.addTarget(self, action: #selector(sortingSwitchValueChanged(sender: )), for: .valueChanged)
        
        settingsView.sortingSwitch.isOn = SettingsModel.shared.isSortingEnabled
    }
    
    
    private func setupView() {
        view.addSubview(settingsView.tableView)
        
        NSLayoutConstraint.activate([
            settingsView.tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsView.tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsView.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        settingsView.tableView.delegate = self
        settingsView.tableView.dataSource = self
        
        settingsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }
    
    @objc func sortingSwitchValueChanged(sender: UISwitch) {
        // Обновите значение сортировки и загрузите файлы после изменения переключателя
        SettingsModel.shared.isSortingEnabled = sender.isOn
        fileModel.loadFilesFromDocuments()
    }
    
    func filesUpdated() {
        DispatchQueue.main.async {
            self.settingsView.tableView.reloadData()
        }
    }
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Сортировка"
            cell.accessoryView = settingsView.sortingSwitch
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Поменять пароль"
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            PasswordManager.shared.startCreatingPassword()
            let loginController = LoginController()
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
            present(navController, animated: true, completion: nil)
        }
    }
}

extension SettingsController: LoginControllerDelegate {
    func loginControllerDidFinishChangingPassword() {
    }
}
