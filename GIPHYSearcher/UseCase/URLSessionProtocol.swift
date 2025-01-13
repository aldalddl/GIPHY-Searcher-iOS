//
//  URLSessionProtocol.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 1/13/25.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
