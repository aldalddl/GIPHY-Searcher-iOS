//
//  GiphyAPIManager.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/21/24.
//

import Foundation

protocol GiphyAPIManagerDelegate {
    func didUpdateData(data: [gifDataModel])
    func didFailWithError(error: NetworkError)
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case parsingFailed
    case networkError(description: String)
    case decodingFailed
}

struct GiphyAPIManager {
    let apiKey: String
    var delegate: GiphyAPIManagerDelegate?
    let session: URLSessionProtocol
    
    init(apiKey: String = Bundle.main.giphyAPIKey, delegate: GiphyAPIManagerDelegate? = nil, session: URLSessionProtocol = URLSession.shared) {
        self.apiKey = apiKey
        self.delegate = delegate
        self.session = session
    }
    
    func fetchTrending() {
        let urlString = "\(API.baseURL)\(API.Endpoint.trending)?api_key=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func fetchSearch(keywords: String) {
        let urlString = "\(API.baseURL)\(API.Endpoint.searching)?api_key=\(apiKey)&q=\(keywords)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError(error: .invalidURL)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.delegate?.didFailWithError(error: .networkError(description: error.localizedDescription))
                return
            }
            
            guard let httpReponse = response as? HTTPURLResponse else {
                self.delegate?.didFailWithError(error: .networkError(description: "Invalid Response"))
                return
            }
            
            switch httpReponse.statusCode {
            case 200..<300:
                guard let data = data else {
                    self.delegate?.didFailWithError(error: .noData)
                    return
                }
                
                if let parsedData = self.parseJSON(data) {
                    self.delegate?.didUpdateData(data: parsedData)
                } else {
                    self.delegate?.didFailWithError(error: .parsingFailed)
                }
            case 400..<500:
                self.delegate?.didFailWithError(error: .networkError(description: "Client Error: \(httpReponse.statusCode)"))
            case 500..<600:
                self.delegate?.didFailWithError(error: .networkError(description: "Server Error: \(httpReponse.statusCode)"))
            default:
                self.delegate?.didFailWithError(error: .networkError(description: "Unexpected HTTP Status Code: \(httpReponse.statusCode)"))
            }
        }
        
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> [gifDataModel]? {
        let decoder = JSONDecoder()
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("받은 JSON 데이터:\n\(jsonString)")
        }
        
        do {
            let decodedData = try decoder.decode(Trending.self, from: data)
            
            let dataList = decodedData.data.map {
                gifDataModel(
                    id: $0.id,
                    url: $0.images.original.url,
                    title: $0.title,
                    username: $0.username,
                    bookmarkButtonActive: false)
            }
            
            return dataList
        } catch let error {
            delegate?.didFailWithError(error: NetworkError.decodingFailed)
            print("디코딩 실패: \(error.localizedDescription)")
            return nil
        }
    }
}
