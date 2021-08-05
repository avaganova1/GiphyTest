//
//  APIDataModel.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import Foundation

struct APIDataModel<T: Decodable>: Decodable {
    let data: T
}
