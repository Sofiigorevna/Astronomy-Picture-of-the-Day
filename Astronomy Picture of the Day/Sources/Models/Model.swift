//
//  Model.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 05.02.2024.
//

import Foundation

// MARK: - PictureData

struct PictureData: Decodable {
    let date: String
    let explanation: String
    let hdurl: String?
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl, title, url
    }
}

