//
//  GiphyApiService.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import Foundation
import Alamofire
import SwiftGifOrigin

class GiphyApiService: GiphyApiServiceProtocol {
    
    func loadCategories(completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        let parameters: Parameters = Parameters(dictionaryLiteral: ApiConfiguration().api_token)
        
        AF.request(RequestPath.url, parameters: parameters, requestModifier: { request in
            request.url?.appendPathComponent(RequestPath.version)
            request.url?.appendPathComponent(RequestPath.ApiMethod.gifs.rawValue)
            request.url?.appendPathComponent(RequestPath.ApiMethod.categories.rawValue)
        }).responseDecodable(of: APIDataModel<[CategoryModel]>.self, queue: .main, completionHandler: { response in
            if let error = response.error { completion(.failure(error)); return }
            
            guard let categories = response.value?.data else { return }
            
            completion(.success(categories))
        })
    }
    
    func loadImage(id:String, needGif: Bool = false, completion: @escaping (Swift.Result<UIImage, Error>) -> Void) {
        let parameters: Parameters = Parameters(dictionaryLiteral: ApiConfiguration().api_token)
        let semaphore = DispatchSemaphore(value: 1)
        
        AF.request(RequestPath.url, parameters: parameters, requestModifier: { request in
            request.url?.appendPathComponent(RequestPath.version)
            request.url?.appendPathComponent(RequestPath.ApiMethod.gifs.rawValue)
            request.url?.appendPathComponent(id)
        }).responseDecodable(of: APIDataModel<GifModel>.self, queue: .global(qos: .background), completionHandler: { response in
            if let error = response.error {
                completion(.failure(error))
                semaphore.signal()
                return
            }
            
            guard let gifUrl = response.value?.data.images.downsized_medium.url else { return }
            
            if let gif = UIImage.gif(url: gifUrl), needGif {
                completion(.success(gif))
                semaphore.signal()
                return
            }
            
            guard let url = URL(string: gifUrl),
                let gifData = try? Data(contentsOf: url),
                let gifImage = UIImage(data: gifData) else { return }
            
            completion(.success(gifImage))
            semaphore.signal()
        })
    }
    
    func loadGifsByTag(tag: String?, completion: @escaping (Result<[GifModel], Error>) -> Void) {
        guard let tag = tag else { return }
        
        let parameters: Parameters = Parameters(dictionaryLiteral: ApiConfiguration().api_token, ("q", tag))
        
        AF.request(RequestPath.url, parameters: parameters, requestModifier: { request in
            request.url?.appendPathComponent(RequestPath.version)
            request.url?.appendPathComponent(RequestPath.ApiMethod.gifs.rawValue)
            request.url?.appendPathComponent(RequestPath.ApiMethod.search.rawValue)
        }).responseDecodable(of: APIDataModel<[GifModel]>.self, queue: .main, completionHandler: { response in
            if let error = response.error { completion(.failure(error)); return }
            
            guard let gifs = response.value?.data else { return }
            
            completion(.success(gifs))
        })
    }
}
