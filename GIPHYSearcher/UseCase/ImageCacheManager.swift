//
//  ImageCacheManager.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/28/24.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let storage = NSCache<NSString, NSData>()
    
    private init() { }
    
    func getCacheImageData(urlString: String) -> Data? {
        let cachedKey = NSString(string: urlString)
        
        if let cachedImageData = storage.object(forKey: cachedKey) {
            return cachedImageData as Data
        }
        
        return nil
    }
    
    func setCacheImage(imageData: Data, urlString: String) {
        let cachedKey = NSString(string: urlString)
        
        storage.setObject(imageData as NSData, forKey: cachedKey)
    }
}
