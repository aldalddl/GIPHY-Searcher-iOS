//
//  Bundle.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/21/24.
//

import Foundation

extension Bundle {
    var giphyAPIKey: String {
        guard let filePath = self.path(forResource: "APIKey", ofType: "plist") else { return "" }
        
        guard let resource = NSDictionary(contentsOfFile: filePath) else { return "" }
        
        guard let key = resource["GIPHY_API_KEY"] as? String else { fatalError("APIKey.plist에 GIPHY_API_KEY 설정") }
        
        return key
    }
}
