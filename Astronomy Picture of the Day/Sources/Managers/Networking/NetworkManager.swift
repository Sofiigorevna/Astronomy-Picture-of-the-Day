//
//  NetworkManager.swift
//  Astronomy Picture of the Day
//
//  Created by 1234 on 05.02.2024.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func fetchAPIData(
        handler: @escaping (([PictureData]) -> Void))
    func fetchRandomLimitData(
        handler: @escaping (([PictureData]) -> Void)
    )
    func fetchDataToDay(
        handler: @escaping ((PictureData) -> Void)
    )
}

fileprivate enum RequestParameter: Int,
                                   CaseIterable {
    case limit = 20
}

class NetworkManager: NetworkServiceProtocol {
    static let sharedInstance = NetworkManager()
    
    public func createURL(baseURL: String, path: String?, queryItems: [URLQueryItem]? = nil) -> URL? {
        // Проверяем, есть ли путь (path)
        if let path = path, !path.isEmpty {
            // Если путь существует и не пуст, создаем URL с полным путем
            var components = URLComponents(string: baseURL)
            components?.path = path
            components?.queryItems = queryItems
            return components?.url
        } else {
            // Если путь отсутствует или пуст, используем базовый URL
            return URL(string: baseURL)
        }
    }
    
    func fetchAPIData(handler: @escaping (([PictureData]) -> Void)) {
        let baseURL = "https://api.nasa.gov"
        let urlPath = "/planetary/apod"
        let queryItem = [URLQueryItem(name: "api_key", value: "kFxHTgfnKwf952EJVActPDNxE141bba43TMcLKiF"),
                         URLQueryItem(name: "start_date", value: "2024-01-01"),
                         URLQueryItem(name: "end_date", value: "2024-01-20")
        ]
        
        let urlRequest = createURL(baseURL: baseURL, path: urlPath, queryItems: queryItem)
        
        guard let url = urlRequest else {return}
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil,
            interceptor: nil
        ).response{ resp in
            switch resp.result{
            case .success(let data):
                do{
                    if let data = data {
                        let jsonData = try JSONDecoder().decode([PictureData].self, from: data)
                        handler(jsonData)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchRandomLimitData(
        handler: @escaping (([PictureData]) -> Void)
    ) {
        let baseURL = "https://api.nasa.gov"
        let urlPath = "/planetary/apod"
        let queryItem = [
            URLQueryItem(name: "api_key", value: "kFxHTgfnKwf952EJVActPDNxE141bba43TMcLKiF"),
            URLQueryItem(name: "count", value: String(RequestParameter.limit.rawValue))
        ]
        
        let urlRequest = createURL(
            baseURL: baseURL,
            path: urlPath,
            queryItems: queryItem
        )
        guard let url = urlRequest else {
            return
        }
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil,
            interceptor: nil
        ).response{ resp in
            switch resp.result{
            case .success(let data):
                do{
                    if let data = data {
                        let jsonData = try JSONDecoder().decode([PictureData].self, from: data)
                        handler(jsonData)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func fetchDataToDay(
        handler: @escaping ((PictureData) -> Void)
    ) {
        let baseURL = "https://api.nasa.gov"
        let urlPath = "/planetary/apod"
        let queryItem = [
            URLQueryItem(name: "api_key", value: "kFxHTgfnKwf952EJVActPDNxE141bba43TMcLKiF"),
            URLQueryItem(name: "date", value: nil)
        ]
        
        let urlRequest = createURL(
            baseURL: baseURL,
            path: urlPath,
            queryItems: queryItem
        )
        
        guard let url = urlRequest else {
            return
        }
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil,
            interceptor: nil
        ).response{ resp in
            switch resp.result{
            case .success(let data):
                do{
                    if let data = data {
                        let jsonData = try JSONDecoder().decode(PictureData.self, from: data)
                        handler(jsonData)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
