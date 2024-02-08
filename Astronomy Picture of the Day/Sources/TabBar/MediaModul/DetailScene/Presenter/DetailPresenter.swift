//
//  DetailPresenter.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 07.02.2024.
//

import Foundation

protocol DetailPresenterType {
    var picture: PictureData? { get set }
    var view: DetailViewProtocol? { get set }
    func configuration()
}

class DetailPresenter: DetailPresenterType {
    var picture: PictureData?
    weak var view: DetailViewProtocol?
    
    required init( view: DetailViewProtocol, picture: PictureData?) {
        self.view = view
        self.picture = picture
    }
    
    public func configuration(){
        self.view?.configuration(model: picture)
    }
}

