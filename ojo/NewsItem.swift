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

// FIXME: I suppose it's safe to assume the JSON item will always have a photo.
// If it doesn't, parsing will fail and we'll just ignore it. This is better for
// the UI. If there isn't a photo, there isn't even a dominant color! That's just
// shitty to look at.

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
        let attributes: Decoded<JSON> = j <| "attributes"
        guard let a = attributes.value else {
            let msg = "Failed to extract attributes from JSON"
            return Decoded<NewsItem>.customError(msg)
        }
        let ni = curry(self.init)
        return ni
            <^> j <| "id"
            <*> a <| "category"
            <*> a <| "title"
            <*> a <| "body"
            <*> a <|? "subtitle"
            <*> a <|? "straphead"
            <*> NewsItem.Photo.decode(a)
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
