//
//  UIViewController+ShowError.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import UIKit

extension UIViewController {
    
    func showError(_ error: Error, indicator: UIActivityIndicatorView? ) {
        let message: String = error.localizedDescription
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true) {
                indicator?.stopAnimating()
            }
        }
    }
}
