//
//  TrendingCollectionViewCell.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/20/24.
//

import Foundation
import UIKit
import SnapKit
import JellyGif

class TrendingCollectionViewCell: UICollectionViewCell {
    let testImageView = JellyGifImageView() 
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.contentView.backgroundColor = .backgroundColor
        self.contentView.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10
    }
    
    func layout() {
        self.contentView.addSubview(testImageView)
        self.contentView.addSubview(bookmarkButton)
        
        testImageView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(5)
        }
    }
}
