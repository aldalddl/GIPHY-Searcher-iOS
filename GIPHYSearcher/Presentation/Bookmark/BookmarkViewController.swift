//
//  BookmarkViewController.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/20/24.
//

import Foundation
import UIKit
import SnapKit
import JellyGif

class BookmarkViewController: UIViewController {
    var bookmarkedData = [gifDataModel]()

    let bookmarkCollectionView: UICollectionView = {
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
        
        self.navigationItem.title = "Bookmark"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        bookmarkCollectionView.dataSource = self
        bookmarkCollectionView.delegate = self
        bookmarkCollectionView.register(TrendingCollectionViewCell.self, forCellWithReuseIdentifier: "BookmarkCollectionViewCell")
    }
    
    func layout() {
        self.view.addSubview(bookmarkCollectionView)
        
        bookmarkCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
}

// MARK: Functions
extension BookmarkViewController {
    @objc func bookmarkButtonDidTapped(_ sender: BookmarkButton) {        
        self.bookmarkedData.remove(at: sender.tag)
        
        }
        
        trendingData[sender.tag].bookmarkButtonActive = !trendingData[sender.tag].bookmarkButtonActive
        sender.setImage(UIImage(systemName: "bookmark"), for: .normal)
        
        self.bookmarkCollectionView.reloadData()
    }
}

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookmarkedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookmarkCollectionViewCell", for: indexPath) as? TrendingCollectionViewCell else {
            return UICollectionViewCell()
        }
                
        if let url = URL(string: self.bookmarkedData[indexPath.row].url) {
            cell.testImageView.startGif(with: .localPath(url))
        }
        
        cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        cell.bookmarkButton.tag = indexPath.row
        cell.bookmarkButton.customTag = self.bookmarkedData[indexPath.row].id
        cell.bookmarkButton.addTarget(self, action: #selector(self.bookmarkButtonDidTapped(_ :)), for: .touchUpInside)
        
        return cell
    }
    
}
