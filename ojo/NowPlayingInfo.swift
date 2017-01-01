//
//  NowPlayingInfo.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/29/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Argo
import Curry
import Runes

struct NowPlayingInfo {
    let title: String
    let artist: String
    let album: String
    let stationTag: String
    let artwork: Artwork

    // decomposed into another struct because of a limitation in the curry lib
    // see: https://github.com/thoughtbot/Argo/blob/master/Documentation/Curry-Limitations.md
    struct Artwork {
        let dominantColor: String?
        let url500: String?
    }
}

extension NowPlayingInfo: Decodable {
    static func decode(_ j: JSON) -> Decoded<NowPlayingInfo> {
        return curry(self.init)
            <^> j <| "title"
            <*> j <| "artist"
            <*> j <| "album"
            <*> j <| "station-tag"
            <*> NowPlayingInfo.Artwork.decode(j)
    }
}

extension NowPlayingInfo.Artwork: Decodable {
    static func decode(_ j: JSON) -> Decoded<NowPlayingInfo.Artwork> {
        return curry(self.init)
            <^> j <|? "artwork-dominant-color"
            <*> j <|? "artwork-url-500"
    }
}
