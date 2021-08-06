//
//  GifsCollectionViewController.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import UIKit

class GifsCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var categoryName: String?
    var collectionView: UICollectionView!
    let indicator = UIActivityIndicatorView()
    
    var gifList: [GifModel]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    let apiService = GiphyApiService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.settingActivityIndicator()
        
        self.indicator.startAnimating()
        
        self.apiService.loadGifsByTag(tag: categoryName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(gifs):
                    self?.gifList = gifs
                    self?.indicator.stopAnimating()

                case let .failure(error):
                    self?.showError(error, indicator: self?.indicator)
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .systemPink
    }
    
    private func setupCollectionView() {
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.createLayout())
        self.collectionView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.collectionView)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(UINib(nibName: "GifCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: "GifCollectionCell")
    }
    
    
    private func settingActivityIndicator() {
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        self.indicator.color = .systemPink
        
        self.collectionView.addSubview(self.indicator)
        
        self.indicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        self.indicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 5
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gifList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCollectionCell", for: indexPath) as? GifCollectionCell else { fatalError("Something wron with item.") }
        
        cell.gifImageView.image = nil
        cell.tag = indexPath.row
        
        guard let gifImageId = self.gifList?[indexPath.item].id else { return GifCollectionCell() }
        
        cell.activityIndicator.startAnimating()
        self.apiService.loadImage(id: gifImageId, needGif: true) { [weak self] result in
            switch result {
            case let .success(gif):
                DispatchQueue.main.async {
                    guard cell.tag == indexPath.row else { return }
                    cell.gifImageView.image = gif
                    cell.activityIndicator.stopAnimating()
                }
            case let .failure(error):
                self?.showError(error, indicator: cell.activityIndicator)
            }
        }
        
        return cell
    }
}
