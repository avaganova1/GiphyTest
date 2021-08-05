//
//  GifModel.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import Foundation

struct GifModel: Decodable {
    let username: String
    let id: String
    let images: ImageTypesModel
}

struct ImageTypesModel: Decodable {
    let downsized_medium: ImageModel
}

struct ImageModel: Decodable {
    let height: String
    let size: String
    let url: String
    let width: String
}
