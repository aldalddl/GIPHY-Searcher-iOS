    let searchURL = "https://api.giphy.com/v1/gifs/search"
    
    func fetchSearch(keywords: String) {
        let urlString = "\(searchURL)?api_key=\(apiKey)&q=\(keywords)"
        print("fetchSearch: \(keywords)")
        performRequest(with: urlString)
    }
    
