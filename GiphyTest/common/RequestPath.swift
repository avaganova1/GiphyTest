//
//  RequestPath.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import Foundation

enum RequestPath {
    static let url = "https://api.giphy.com"
    static let version: String = "v1"
    
    enum ApiMethod: String {
        case categories
        case search
        case gifs
    }
    
    enum ApiFilter: String {
        case tags
    }
}
