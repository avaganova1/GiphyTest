//
//  URL+getData.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 06.08.2021.
//

import UIKit

extension URL {
    func getData(completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: self, completionHandler: completion).resume()
    }
}
