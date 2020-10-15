//
//  FeedViewModel.swift
//  FeedApp
//
//  Created by Андрей Останин on 01.10.2020.
//

import Foundation
import UIKit

protocol FeedViewModelDelegate {
    func startedLoading()
    func endedLoading()
}

class FeedViewModel {
    // MARK: - Props
    private var feed: Feed?
    private var posts: [PostViewModel] = []
    private let networkService = NetworkService()
    private var currentOrder: NetworkService.Ordered = .createdAt
    
    var delegate: FeedViewModelDelegate?
    
    // MARK: - Load
    func fetchFeed(orderBy: NetworkService.Ordered, clearPrevious: Bool, completion: @escaping () -> Void) {
        if posts.count >= 1, feed?.data?.cursor == nil, orderBy == currentOrder { return }
        
        if clearPrevious {
            self.feed = nil
            self.posts = []
        }
        
        currentOrder = orderBy
        delegate?.startedLoading()
        
        networkService.loadFeed(orderBy: currentOrder, afterCursor: feed?.data?.cursor) { (feed) in
            DispatchQueue.main.async {
                self.feed = feed
                
                if let items = feed.data?.items {
                    items.forEach { (item) in
                        self.posts.append(PostViewModel(post: item))
                    }
                }
                
                completion()
                self.delegate?.endedLoading()
            }
        }
        
    }
    
    // MARK: - Set/get
    func numberOfItems() -> Int{
        return posts.count
    }
    
    func post(for index: Int) -> PostViewModel {
        return posts[index]
    }
    
    // MARK: - Logic
    func checkIfTheLast(index: Int, completion: @escaping () -> Void) {
        if index == posts.count-1 {
            fetchFeed(orderBy: currentOrder, clearPrevious: false) {
                completion()
            }
            
        }
    }
    
}
