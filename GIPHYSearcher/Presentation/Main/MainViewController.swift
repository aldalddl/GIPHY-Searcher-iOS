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
    var bookmarkedData = [gifDataModel]()
    var searchData = [gifDataModel]()
    
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
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        setUp()
        layout()
        
        apiSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let data = UserDefaults.standard.object(forKey: "bookmarkedData") as? Data,
           let decoded = try? JSONDecoder().decode([gifDataModel].self, from: data) {
            bookmarkedData = decoded
        }
        
        trendingCollectionView.reloadData()
    }
    
    func setUp() {
        self.view.backgroundColor = .backgroundColor
        
        self.navigationItem.title = "GIPHY Searcher"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search GIFs"
        searchController.searchResultsUpdater = self
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

// MARK: UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        searchApiSetUp(text: text)
        
        self.trendingCollectionView.reloadData()
    }
}

// MARK: Functions
extension MainViewController {
    @objc func bookmarkButtonDidTapped(_ sender: BookmarkButton) {
        let navigationViewController = tabBarController?.viewControllers![1] as! UINavigationController
        let bookmarkViewController = navigationViewController.topViewController as! BookmarkViewController
        var buttonActive = trendingData[sender.tag].bookmarkButtonActive
        
        if !buttonActive {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            self.bookmarkedData.append(trendingData[sender.tag])
        } else {
            sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
            
            if let filteredIndex = trendingData.firstIndex(where: { $0.id == sender.customTag }) {
                self.bookmarkedData.remove(at: filteredIndex)
            }
        }
    
        if let encoded = try? JSONEncoder().encode(self.bookmarkedData) {
            UserDefaults.standard.set(encoded, forKey: "bookmarkedData")
        }
        
        buttonActive = !buttonActive

        bookmarkViewController.bookmarkCollectionView.reloadData()
    }
}

// MARK: API Response
extension MainViewController: GiphyAPIManagerDelegate {
    func didUpdateData(data: [gifDataModel]) {
        if self.isFiltering {
            searchData = data
        } else {
            trendingData = data
        }

        print(data)
        
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
    
    func searchApiSetUp(text: String) {
        trendingAPIManager.delegate = self
        trendingAPIManager.fetchSearch(keywords: text)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isFiltering ? self.searchData.count : trendingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as? TrendingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let placeholder = "LoadingImage"
        var url = URL(string: "")
        cell.bookmarkButton.tag = indexPath.row

        if self.isFiltering {
            url = URL(string: searchData[indexPath.row].url)
            
            cell.imageView.setImage(url: url, placeholder: placeholder)
            
            let cellId = searchData[indexPath.row].id
            
            if self.bookmarkedData.contains(where: { $0.id == cellId }) {
                cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                searchData[indexPath.row].bookmarkButtonActive = true
            } else {
                cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                searchData[indexPath.row].bookmarkButtonActive = false
            }
            
            cell.bookmarkButton.customTag = searchData[indexPath.row].id
        } else {
            url = URL(string: trendingData[indexPath.row].url)
            
            cell.imageView.setImage(url: url, placeholder: placeholder)
            
            let cellId = trendingData[indexPath.row].id
            
            if self.bookmarkedData.contains(where: { $0.id == cellId }) {
                cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                trendingData[indexPath.row].bookmarkButtonActive = true
            } else {
                cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                trendingData[indexPath.row].bookmarkButtonActive = false
            }
            
            cell.bookmarkButton.customTag = trendingData[indexPath.row].id
        }
        
        cell.bookmarkButton.addTarget(self, action: #selector(self.bookmarkButtonDidTapped(_ :)), for: .touchUpInside)

        return cell
    }
    
}
