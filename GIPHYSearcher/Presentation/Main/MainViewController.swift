//
//  ViewController.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/19/24.
//

import UIKit
import SnapKit
import JellyGif

class MainViewController: UIViewController {
    var trendingAPIManager = TrendingAPIManager()
    var trendingData = [gifDataModel]()

    let trendingCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.minimumLineSpacing = 8
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 48) / 2, height: 150)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .backgroundColor
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    var bookmarkButtonActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        setUp()
        layout()
        
        apiSetUp()
    }
    
    func setUp() {
        self.view.backgroundColor = .backgroundColor
        
        self.navigationItem.title = "GIPHY Searcher"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search GIFs"
        self.navigationItem.searchController = searchController
        
        trendingCollectionView.dataSource = self
        trendingCollectionView.delegate = self
        trendingCollectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: "TrendingCollectionViewCell")
    }
    
    func layout() {
        self.view.addSubview(trendingCollectionView)
        
        trendingCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}

// MARK: Functions
extension MainViewController {
    @objc func bookmarkButtonDidTapped(_ sender: UIButton) {
        bookmarkButtonActive = !bookmarkButtonActive
        
        let navVC = tabBarController?.viewControllers![1] as! UINavigationController
        let bookmarkVC = navVC.topViewController as! BookmarkViewController
        
        if bookmarkButtonActive {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            bookmarkVC.bookmarkedData.append(self.trendingData[sender.tag])
        } else {
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
            bookmarkVC.bookmarkedData.remove(at: sender.tag)
        }
        
        bookmarkVC.bookmarkCollectionView.reloadData()
    }
}

// MARK: API Response
extension MainViewController: TrendingAPIManagerDelegate {
    func didUpdateTrending(data: [gifDataModel]) {
        self.trendingData = data
        
        DispatchQueue.main.async {
            self.trendingCollectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func apiSetUp() {
        trendingAPIManager.delegate = self
        trendingAPIManager.fetchTrending()
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.trendingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as? TrendingCollectionViewCell else {
            return UICollectionViewCell()
        }
                        
        guard let imageUrl = URL(string: trendingData[indexPath.row].url) else {
            cell.testImageView.startGif(with: .name("LoadingImage"))
            return cell
        }

        if let cacheImage = ImageCacheManager.shared.getCacheImageData(urlString: imageUrl.absoluteString) {
            if indexPath == collectionView.indexPath(for: cell) {
                cell.testImageView.startGif(with: .data(cacheImage))
            }
        } else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    ImageCacheManager.shared.setCacheImage(imageData: data, urlString: imageUrl.absoluteString)
                    cell.testImageView.startGif(with: .localPath(imageUrl))
                }
            }
        }
        
        cell.bookmarkButton.tag = indexPath.row
        cell.bookmarkButton.addTarget(self, action: #selector(self.bookmarkButtonDidTapped(_ :)), for: .touchUpInside)
        
        return cell
    }
    
}
