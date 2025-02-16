//
//  MockURLSession.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 12/13/24.
//

import Foundation
@testable import GIPHYSearcher

class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data?, reponse: URLResponse?, error: Error?)
    
    var responseForURL: [String: Response] = [:]
    
    init(response: Response) {
        self.responseForURL = ["default": response]
    }
    
    init(responseForURL: [String: Response]) {
        self.responseForURL = responseForURL
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let urlString = url.absoluteString
        var response = responseForURL[urlString] ?? responseForURL["default"]!
        
        if urlString.contains("q=funny"), let data = response.data {
            response.data = filterData(byKeyword: "funny", from: data)
        }
        
        return MockURLSessionDataTask(resumeHandler: {
            completionHandler(response.data,
                              response.reponse,
                              response.error)
        })
    }
}

private func filterData(byKeyword keyword: String, from data: Data) -> Data {
    let decoder = JSONDecoder()
    
    if let decoded = try? decoder.decode(Trending.self, from: data) {
        let filteredData = decoded.data.filter { $0.title.contains(keyword) }
        let filteredTrending = Trending(data: filteredData)
        
        return try! JSONEncoder().encode(filteredTrending)
    }
    
    return data
}
