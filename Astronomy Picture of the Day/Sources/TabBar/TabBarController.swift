//
//  TabBarController.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 05.02.2024.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarController()
        setupTabBarViewControllers()
    }
    
    func setupTabBarController() {
        delegate = self
        tabBar.backgroundColor = .systemBackground
        self.tabBar.tintColor = .black
    }
    
    func setupTabBarViewControllers() {
        let mainVC = DependencyFactory().makeInitialViewController()
        let mediaController =  UINavigationController(rootViewController: mainVC)
        let mediaControllerIcon = UITabBarItem(title: "Picture Library",
                                     image: UIImage(systemName: "rectangle.stack.fill"),
                                     selectedImage: UIImage(systemName: "rectangle.stack.fill"))
        mediaController.tabBarItem = mediaControllerIcon
        
        let mainSearchVC = DependencyFactory().makeSearchViewController()

        let searchController = UINavigationController(rootViewController: mainSearchVC)
        let searchControllerIcon = UITabBarItem(title: "Search",
                                      image: UIImage(systemName: "magnifyingglass"),
                                      selectedImage: UIImage(systemName: "magnifyingglass"))
        searchController.tabBarItem = searchControllerIcon
        
        let controllers = [mediaController, searchController]
        self.setViewControllers(controllers, animated: true)
    }
}


