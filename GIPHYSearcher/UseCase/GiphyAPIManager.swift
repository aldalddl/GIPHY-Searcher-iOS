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
}

struct GiphyAPIManager {
    let trendingURL = "https://api.giphy.com/v1/gifs/trending"
    let searchURL = "https://api.giphy.com/v1/gifs/search"
    
    let apiKey = Bundle.main.giphyAPIKey
    var delegate: GiphyAPIManagerDelegate?
    
    func fetchTrending() {
        let urlString = "\(trendingURL)?api_key=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func fetchSearch(keywords: String) {
        let urlString = "\(searchURL)?api_key=\(apiKey)&q=\(keywords)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            delegate?.didFailWithError(error: .invalidURL)
            return
        }
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.delegate?.didFailWithError(error: .networkError(description: error.localizedDescription))
                    return
                }
                
                guard let data = data else {
                    self.delegate?.didFailWithError(error: .noData)
                    return
                }
                
                if let parsedData = self.parseJSON(data) {
                    self.delegate?.didFailWithError(error: .parsingFailed)
                }
            }
            
            task.resume()
    }
    
    func parseJSON(_ data: Data) -> [gifDataModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Trending.self, from: data)
            let data = decodedData.data
            var dataList = [gifDataModel]()
            
            var id = ""
            var url = ""
            var title = ""
            var username = ""
                        
            for index in 0..<data.count {
                id = decodedData.data[index].id
                url = decodedData.data[index].images.original.url
                title = decodedData.data[index].title
                username = decodedData.data[index].username
                
                dataList.append(gifDataModel(id: id, url: url, title: title, username: username, bookmarkButtonActive: false))
            }
            
            return dataList
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
