//
//  PostViewModel.swift
//  FeedApp
//
//  Created by Андрей Останин on 01.10.2020.
//

import Foundation
import UIKit

class PostViewModel {
    
    // MARK: - Props
    private let post: Item
    private var textLabel: String?
    private var postImage: PostImage?
    private var image: UIImage? = nil
    
    // MARK: - Calculated props
    var name: String {
        if let name = post.author?.name {
            return name
        } else {
            return "no name"
        }
    }
    
    var likes: Int {
        return post.stats.likes.count
    }
    
    var views: Int {
        return post.stats.views.count
    }
    
    // MARK: - init
    init(post: Item) {
        self.post = post
    }
    
    // MARK: - Set/get
    func postTextLabel() -> String {
        guard let text = textLabel else {
            return ""
        }
        return text
    }
    
    func setImageUrl(for data: ContentData) {
        if let imgES = data.extraSmall {
            if let imgS = data.small {
                if let imgM = data.medium {
                    postImage = imgM
                    return
                }
                postImage = imgS
                return
            }
            postImage = imgES
        }
    }
    
    func getPostImage(completion: @escaping (UIImage) -> Void) {
        if let img = image {
            completion(img)
        } else {
            loadImage { (loadedImg) in
                self.image = loadedImg
                completion(loadedImg)
            }
        }
    }
    
    // MARK: - Load
    func parseContent() {
        post.contents.forEach { (content) in
            switch content.type {
            case "TEXT":
                textLabel = content.data.value
                break
            case "IMAGE":
                setImageUrl(for: content.data)
                break
            default:
                break
            }
        }
    }
    
    
    // переместить функционал в NwService
    func loadImage(completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: postImage?.url ?? "") else {
            if let sample = UIImage(named: "sample") {
                completion(sample)
            }
            return
        }
        
        DispatchQueue.global().async {
            do {
                let imgData = try Data(contentsOf: url)
                
                if let img = UIImage(data: imgData) {
                    completion(img)
                }
                else {
                    if let sample = UIImage(named: "sample") {
                        completion(sample)
                    }
                }
            } catch {
                print("Error loading image", error)
            }
        }
        
    }
    
}
