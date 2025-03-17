//
//  TrendingAPIData.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/21/24.
//

import Foundation

struct Trending: Codable {
    let data: [GifData]
}

struct GifData: Codable {
    let id: String
    let title: String
    let username: String
    let images: Images
}

struct Images: Codable {
    let original: Original
}

struct Original: Codable {
    let url: String
}

