//
//  CategoryCell.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
        
    func setup(categoryNameLabel: String, gifImage: UIImage) {
        self.categoryNameLabel.text = categoryNameLabel
        self.gifImageView.image = gifImage
    }
}
