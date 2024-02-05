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
        let mediaController =  UINavigationController(rootViewController: MediaLibraryController())
        let mediaControllerIcon = UITabBarItem(title: "Picture Library",
                                     image: UIImage(systemName: "photo.fill.on.rectangle.fill"),
                                     selectedImage: UIImage(systemName: "photo.fill.on.rectangle.fill"))
        mediaController.tabBarItem = mediaControllerIcon
        
        let searchController = UINavigationController(rootViewController: SearchViewController())
        let searchControllerIcon = UITabBarItem(title: "Search",
                                      image: UIImage(systemName: "magnifyingglass"),
                                      selectedImage: UIImage(systemName: "magnifyingglass"))
        searchController.tabBarItem = searchControllerIcon
        
        let controllers = [mediaController, searchController]
        self.setViewControllers(controllers, animated: true)
    }
}


