//
//  TabBarController.swift
//  FileManager
//
//  Created by Liz-Mary on 09.09.2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .systemMint
        setupTabs()
    }
    
    private func setupTabs() {
        let filesListVC = ViewController()
        let settingsVC = SettingsController()
        
        let filesListNav = UINavigationController(rootViewController: filesListVC)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        filesListVC.title = "Файлы"
        filesListVC.tabBarItem = UITabBarItem(title: "Файлы", image: UIImage(systemName: "folder.fill"), tag: 0)
        settingsVC.title = "Настройки"
        settingsVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape.fill"), tag: 1)
        
        viewControllers = [filesListNav, settingsNav]
    }
}
