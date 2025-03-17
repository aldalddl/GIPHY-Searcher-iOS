//
//  API.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 12/14/24.
//

struct API {
    static let baseURL = "https://api.giphy.com"
    
    struct Endpoint {
        static let trending = "/v1/gifs/trending"
        static let searching = "/v1/gifs/search"
    }
}
