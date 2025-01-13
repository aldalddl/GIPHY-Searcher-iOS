//
//  MockURLSession.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 12/13/24.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data?, reponse: URLResponse?, error: Error?)
    
    let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(resumeHandler: {
            completionHandler(self.response.data,
                              self.response.reponse,
                              self.response.error)
        })
    }
}
