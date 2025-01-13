//
//  URLSessionDataTaskProtocol.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 1/13/25.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
