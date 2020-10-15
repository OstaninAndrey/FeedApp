//
//  Feed.swift
//  FeedApp
//
//  Created by Андрей Останин on 03.10.2020.
//

import Foundation
import UIKit

struct Feed: Decodable {
    let data: PostsData?
}

struct PostsData: Decodable {
    let items: [Item]
    let cursor: String?
}

struct Item: Decodable {
    let id: String
    let contents: [Content]
    let author: Author?
    let stats: Stats
}

struct Content: Decodable {
    let type: String
    let data: ContentData
}

struct Author: Decodable {
    let name: String
    let photo: ContentData?
}

struct Stats: Decodable {
    let likes: Likes
    let views: PostViews
}

struct ContentData: Decodable {
    let value: String?
    let extraSmall: PostImage?
    let small: PostImage?
    let medium: PostImage?
}

struct PostImage: Decodable {
    let url: String
    let size: Size
}

struct Likes: Decodable {
    let count: Int
}

struct PostViews: Decodable {
    let count: Int
}

struct Size: Decodable {
    let width: Int
    let height: Int
}
