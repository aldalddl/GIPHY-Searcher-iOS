//
//  UIImageViewExtension.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 4/23/24.
//

import Foundation
import UIKit
import SnapKit

class UIImageViewExtension: UIImageView {
    var savedTask: URLSessionTask?
    var savedURL: URL?
}

extension UIImageView {
    func setImage(url: URL?, placeholder: String?) {
        var view = UIImageViewExtension()

        view.savedTask?.cancel()
        view.savedTask = nil
        
        guard 
            let url,
            let placeholder
        else { return }
        
        guard
            let placeholderUrl = Bundle.main.url(forResource: placeholder, withExtension: "gif"),
            let placeholderData = try? Data(contentsOf: placeholderUrl)
        else { return }
        
        startAnimation(gifData: placeholderData)
        
        if let cachedImage = ImageCacheManager.shared.getCacheImageData(urlString: url.absoluteString) {
            self.startAnimation(gifData: cachedImage)
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
                        self.startAnimation(gifData: data)
                    }
                }
            }
            
            view.savedURL = url
            view.savedTask = task
            task.resume()
        }
    }
    
    func startAnimation(gifData: Data) {
        guard let source = CGImageSourceCreateWithData(gifData as CFData, nil) else { return }
        
        let frameCount = CGImageSourceGetCount(source)
        var images = [UIImage]()
        
        (0..<frameCount)
            .compactMap { CGImageSourceCreateImageAtIndex(source, $0, nil) }
            .forEach { images.append(UIImage(cgImage: $0)) }
        
        self.animationImages = images
        self.animationDuration = TimeInterval(frameCount) * 0.15
        self.animationRepeatCount = 0
        self.startAnimating()
    }
}
