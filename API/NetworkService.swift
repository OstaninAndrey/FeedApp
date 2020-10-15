//
//  NetworkService.swift
//  FeedApp
//
//  Created by Андрей Останин on 01.10.2020.
//

import Foundation

class NetworkService {
    // MARK: - Props
    private let baseUrl = "http://stage.apianon.ru:3000/fs-posts/v1/posts"
    private let first = "?first=20"
    
    enum Ordered {
        case mostPopular
        case mostCommented
        case createdAt
    }
    
    // MARK: - Methods (load/parse)
    private func makeUrlString(orderBy: Ordered, afterCursor: String?) -> String {
        var url = baseUrl
        
        url += first
        switch orderBy {
        case .createdAt:
            url += "&orderBy=createdAt"
            break
        case .mostCommented:
            url += "&orderBy=mostCommented"
            break
        case .mostPopular:
            url += "&orderBy=mostPopular"
            break
        }
        
        if let cursor = afterCursor {
            url += "&after=\(cursor)"
        }
        
        print(url)
        return url
    }
    
    func loadFeed(orderBy: Ordered, afterCursor: String?, completion: @escaping (Feed) -> Void) {
        let urlString = makeUrlString(orderBy: orderBy, afterCursor: afterCursor)
        if let url = URL(string: urlString) {
            
            let session = URLSession.shared
            session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error loading feed data:", error)
                }
                
                guard let safeData = data else { return }
                
                if let feed = self.parseFeedJSON(from: safeData) {
                    completion(feed)
                }
                
            }.resume()
        } else {
            print("Error creating URL")
        }
    }
    
    private func parseFeedJSON(from data: Data) -> Feed?{
        let decoder = JSONDecoder()
        
        do {
            let model = try decoder.decode(Feed.self, from: data)
            
            return model
        } catch {
            print("Error parsing feed data:", error)
        }
        return nil
    }
    
}
