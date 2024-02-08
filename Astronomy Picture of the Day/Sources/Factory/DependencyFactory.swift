//
//  DependencyFactory.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 07.02.2024.
//

import UIKit

protocol Factory {
    func makeInitialViewController() -> UIViewController
    func makeDetaillViewController(data: PictureData) -> UIViewController
}

class DependencyFactory: Factory {
    static let shared = DependencyFactory()

    func makeDetaillViewController(data: PictureData) -> UIViewController {
        let viewController = DetailViewController()
        let presenter = DetailPresenter(view: viewController, picture: data)
        viewController.presenter = presenter
        return viewController
    }
    
    func makeInitialViewController() -> UIViewController {
        let viewController = MediaLibraryController()
        let networkService = NetworkManager()
        let presenter = MainPresenter(view: viewController, networkService: networkService)
        viewController.mainPresenter = presenter
        return viewController
    }
    
    func makeSearchViewController() -> UIViewController {
        let viewController = SearchViewController()
        let networkService = NetworkManager()
        let presenter = SearchPresenter(view: viewController, networkService: networkService)
        viewController.presenter = presenter
        return viewController
    }
}
