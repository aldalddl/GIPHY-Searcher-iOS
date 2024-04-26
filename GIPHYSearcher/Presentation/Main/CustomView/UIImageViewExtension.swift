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

class UIImageViewExtension: UIImageView {
    var savedTask: URLSessionTask?
    var savedURL: URL?
}

extension UIImageView {
    func setImage(url: URL?, placeholder: String?) {
        var gifView = JellyGifImageView()
        
        self.addSubview(gifView)
        gifView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        var view = UIImageViewExtension()

        view.savedTask?.cancel()
        view.savedTask = nil
        
        guard let placeholder else { return }
        gifView.startGif(with: .name(placeholder))
        
        guard let url else { return }
        
        if let cachedImage = ImageCacheManager.shared.getCacheImageData(urlString: url.absoluteString) {
            gifView.startGif(with: .data(cachedImage))
        } else {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error {
                    print(error)
                    return
                }
                
                guard let data else { return }
                ImageCacheManager.shared.setCacheImage(imageData: data, urlString: url.absoluteString)
                if url == view.savedURL {
                    DispatchQueue.main.async {
                        gifView.startGif(with: .data(data))
                    }
                }
            }
            
            view.savedURL = url
            view.savedTask = task
            task.resume()
        }
    }
}
