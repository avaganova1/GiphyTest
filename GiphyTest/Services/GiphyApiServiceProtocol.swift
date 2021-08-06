//
//  GiphyApiServiceProtocol.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import UIKit

protocol GiphyApiServiceProtocol {
    func loadCategories(completion: @escaping (Swift.Result<[CategoryModel], Error>) -> Void)
    func loadGifsByTag(tag: String?, completion: @escaping (Swift.Result<[GifModel], Error>) -> Void)
    func loadImage(id: String, needGif: Bool, completion: @escaping (Swift.Result<UIImage?, Error>) -> Void)
}
