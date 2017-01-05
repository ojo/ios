//
//  NewsItem.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/5/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import Argo
import Curry
import Runes

struct NewsItem {
    let id: Int
    let category: String
    let title: String
    let body: String
    let subtitle: String?
    let straphead: String?
    
    let photo: Photo
    
    struct Photo {
        let thumbURL: String
        let dominantColor: String
        let URL: String
        let caption: String?
    }
}

extension NewsItem: Decodable {
    static func decode(_ j: JSON) -> Decoded<NewsItem> {
        let ni = curry(self.init)
        return ni
            <^> j <| "id"
            <*> j <| "category"
            <*> j <| "title"
            <*> j <| "body"
            <*> j <|? "subtitle"
            <*> j <|? "straphead"
            <*> NewsItem.Photo.decode(j)
    }
}

extension NewsItem.Photo: Decodable {
    static func decode(_ j: JSON) -> Decoded<NewsItem.Photo> {
        let p = curry(self.init)
        return p
            <^> j <| "photo-thumb-url"
            <*> j <| "photo-dominant-color"
            <*> j <| "photo-url"
            <*> j <|? "photo-caption"
    }
}
