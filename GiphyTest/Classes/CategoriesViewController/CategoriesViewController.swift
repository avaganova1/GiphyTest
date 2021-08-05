//
//  CategoriesViewController.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import UIKit

class CategoriesViewController: UITableViewController {
    
    var list: [CategoryModel] = []
    
    let apiService = GiphyApiService()
    let indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        self.settingTableView()
        self.settingActivityIndicator()
        
        self.indicator.startAnimating()
        
        self.apiService.loadCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(categories):
                    self?.list = categories
                    
                    self?.tableView.reloadData()
                    
                    self?.indicator.stopAnimating()
                    
                case let .failure(error):
                    self?.showError(error, indicator: self?.indicator)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    private func settingTableView() {
        self.title = "GIPHY"
        self.tableView.tintColor = .white
        self.tableView.register(UINib(nibName: "CategoryCell", bundle: Bundle.main), forCellReuseIdentifier: "CategoryCell")
    
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func settingActivityIndicator() {
        self.indicator.color = .systemPink
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.addSubview(self.indicator)
        
        self.indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        self.indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell else {
            fatalError("Wrong cell")
        }
        
        cell.gifImageView.image = nil
        cell.tag = indexPath.row
        
        let category = self.list[indexPath.row]
        
        cell.categoryNameLabel.text = category.name
        cell.activityIndicator.startAnimating()
        
        self.apiService.loadImage(id: category.gif.id) { [weak self] result in
            
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    guard cell.tag == indexPath.row else { return }
                    cell.gifImageView.image = image
                    cell.activityIndicator.stopAnimating()
                }
            case let .failure(error):
                self?.showError(error, indicator: cell.activityIndicator)
            }
        }
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = GifsCollectionViewController()
        controller.categoryName = self.list[indexPath.row].name
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - Objc
    
    @objc func handleRefreshControl() {
        
        self.apiService.loadCategories { [weak self] result in
            switch result {
            case let .success(categories):
                self?.list = categories
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                }
                
            case let .failure(error):
                self?.showError(error, indicator: self?.indicator)
            }
        }
    }
}
