//
//  JsonLoader.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 12/13/24.
//


import Foundation

struct JsonLoader {
    static func data(fileName: String) -> Data? {
        let bundle = Bundle(for: GIPHYSearcherTests.self)
        
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            return try? Data(contentsOf: url)
        }
        
        return nil
    }
}
