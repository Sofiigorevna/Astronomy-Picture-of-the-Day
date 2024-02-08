//
//  MainPresenter.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 07.02.2024.
//

import Foundation

protocol MainPresenterType {
    var pictures: [PictureData] {get}
    var pictureToDay: [PictureData] {get}
    func fetchAll()
    func prepareNewData()
    func getPictureToDay()
}

class MainPresenter: MainPresenterType {
    
    weak private var view: MainViewProtocol?
    let networkService: NetworkServiceProtocol?
    
    var pictures = [PictureData]()
    var pictureToDay = [PictureData]()
    
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
        fetchAll()
        getPictureToDay()
    }
    
    func fetchAll() {
        networkService?.fetchAPIData(
            handler: { [weak self] apiData in
                guard self != nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.pictures = apiData
                    self?.view?.succes()
                }
            }
        )
    }
    
    func getPictureToDay() {
        networkService?.fetchDataToDay(
            handler: { [weak self] apiData in
                guard self != nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.pictureToDay.append(apiData)
                    self?.view?.succes()
                }
            }
        )
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
}

