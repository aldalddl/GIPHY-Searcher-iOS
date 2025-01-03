//
//  MockURLSessionDataTask.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 12/13/24.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

class MockURLSessionDataTask: URLSessionDataTask {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    override func resume() {
        resumeHandler()
    }
}
