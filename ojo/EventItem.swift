//
//  EventItem.swift
//  ojo
//
//  Created by Narayana Reddy on 17/02/17.
//  Copyright © 2017 TTRN. All rights reserved.
//


import Argo
import Curry
import Runes

// FIXME: I suppose it's safe to assume the JSON item will always have a photo.
// If it doesn't, parsing will fail and we'll just ignore it. This is better for
// the UI. If there isn't a photo, there isn't even a dominant color! That's just
// shitty to look at.

struct EventItem {
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

extension EventItem: Decodable {
    static func decode(_ j: JSON) -> Decoded<EventItem> {
        let attributes: Decoded<JSON> = j <| "attributes"
        guard let a = attributes.value else {
            let msg = "Failed to extract attributes from JSON"
            return Decoded<EventItem>.customError(msg)
        }
        let id = j <| "id" >>- toInt
        let ni = curry(self.init)
        return ni
            <^> id
            <*> a <| "category"
            <*> a <| "title"
            <*> a <| "body"
            <*> a <|? "subtitle"
            <*> a <|? "straphead"
            <*> EventItem.Photo.decode(a)
    }
}

extension EventItem.Photo: Decodable {
    static func decode(_ j: JSON) -> Decoded<EventItem.Photo> {
        let p = curry(self.init)
        return p
            <^> j <| "photo-thumb-url"
            <*> j <| "photo-dominant-color"
            <*> j <| "photo-url"
            <*> j <|? "photo-caption"
    }
}
