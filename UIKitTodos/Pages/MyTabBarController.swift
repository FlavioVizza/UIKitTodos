//
//  MyTabBarController.swift
//  UIKitTodos
//
//  Created by Flavio Vizza on 16/04/24.
//

import UIKit

/// A custom tab bar controller for managing the main tabs of the application.
class MyTabBarController: UITabBarController {

    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemRed
     
        initTabBarItems()
    }
    
    /// Initializes the tab bar items with appropriate titles and icons.
    func initTabBarItems(){
        viewControllers?[0].tabBarItem = UITabBarItem(title: "todos".translate(), image: UIImage(systemName: "square.and.pencil"), tag: 0)
        viewControllers?[1].tabBarItem = UITabBarItem(title: "settings".translate(), image: UIImage(systemName: "gear"), tag: 1)
    }
    
}
