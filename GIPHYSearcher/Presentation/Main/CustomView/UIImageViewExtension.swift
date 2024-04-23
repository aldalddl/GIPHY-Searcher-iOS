//
//  UIImageViewExtension.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 4/23/24.
//

import Foundation
import UIKit
import SnapKit
import JellyGif


extension UIImageView {
    func setImage(url: URL?, placeholder: String?) {
        var gifView = JellyGifImageView()
        
        self.addSubview(gifView)
        gifView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        guard let placeholder else { return }
        gifView.startGif(with: .name(placeholder))
        
        guard let url else { return }
        
        if let cachedImage = ImageCacheManager.shared.getCacheImageData(urlString: url.absoluteString) {
            gifView.startGif(with: .data(cachedImage))
        } else {
                guard let data else { return }
                ImageCacheManager.shared.setCacheImage(imageData: data, urlString: url.absoluteString)
                if url == view.savedURL {
                    DispatchQueue.main.async {
                        gifView.startGif(with: .data(data))
                    }
                }
    }
}
