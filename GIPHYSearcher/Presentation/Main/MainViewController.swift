//
//  ViewController.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/19/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        setUp()
        layout()
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: 샘플 데이터 수를 서버 데이터 수로 대체하는 작업 필요
        return 13
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as? TrendingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // TODO: 샘플 데이터를 서버 데이터로 대체하는 작업 필요
        cell.testImageView.image = UIImage(named: "TestImage")
        
        return cell
    }
    
}
