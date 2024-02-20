//
//  MainTabBarController.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/20/24.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeNC = UINavigationController(rootViewController: MainViewController())
        let bookmarkNC = UINavigationController(rootViewController: BookmarkViewController())
        let settingNC = UINavigationController(rootViewController: SettingViewController())
        
        self.viewControllers = [homeNC, bookmarkNC, settingNC]
        
        let homeTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        let bookmarkTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "bookmark"), tag: 1)
        let settingTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "gearshape"), tag: 2)
        
        homeNC.tabBarItem = homeTabBarItem
        bookmarkNC.tabBarItem = bookmarkTabBarItem
        settingNC.tabBarItem = settingTabBarItem
    }
    
}
