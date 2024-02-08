//
//  Presenter.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 07.02.2024.
//

import UIKit

protocol SearchPresenterType {
    var pictures: [PictureData] { get set }
    var view: MainViewProtocol? { get set }
    func prepareNewData()
    func fetchAll()
}

class SearchPresenter: SearchPresenterType {
    
    weak internal var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol?
    
    var pictures = [PictureData]()
    
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        fetchAll()
    }
    
    func fetchAll() {
        networkService?.fetchAPIData(handler: { [weak self] apiData in
            guard self != nil else {return}
            DispatchQueue.main.async {
                self?.pictures = apiData
                self?.view?.succes()
            }
        })
    }
    
    func prepareNewData() {
        networkService?.fetchRandomLimitData(
            handler: { [weak self] apiData in
                guard self != nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.pictures.append(contentsOf: apiData)
                    self?.view?.succes()
                }
            }
        )
    }
    
    func updateCollection(_ array: [PictureData]) {
       
            DispatchQueue.main.async {
                self.pictures = array
                self.view?.succes()
            }
        
    }
}


