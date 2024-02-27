//
//  TrendingAPIManager.swift
//  GIPHYSearcher
//
//  Created by 강민지 on 2/21/24.
//

import Foundation

protocol TrendingAPIManagerDelegate {
    func didUpdateTrending(data: [TredingDataModel])
    func didFailWithError(error: Error)
}

struct TrendingAPIManager {
    let trendingURL = "https://api.giphy.com/v1/gifs/trending"
    let apiKey = Bundle.main.giphyAPIKey
    var delegate: TrendingAPIManagerDelegate?
    
    func fetchTrending() {
        let urlString = "\(trendingURL)?api_key=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let trendingData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateTrending(data: trendingData)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ trendingData: Data) -> [TredingDataModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Trending.self, from: trendingData)
            let data = decodedData.data
            var trendingData = [TredingDataModel]()
            
            var id = ""
            var url = ""
            var title = ""
            var username = ""
                        
            for index in 0..<data.count {
                id = decodedData.data[index].id
                url = decodedData.data[index].images.original.url
                title = decodedData.data[index].title
                username = decodedData.data[index].username
                
                trendingData.append(TredingDataModel(id: id, url: url, title: title, username: username))
            }
            
            return trendingData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
