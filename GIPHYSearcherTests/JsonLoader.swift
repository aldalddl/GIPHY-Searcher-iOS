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
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("\(fileName).json 파일을 찾을 수 없습니다.")
        }
        
        return try! Data(contentsOf: url)
    }
}
