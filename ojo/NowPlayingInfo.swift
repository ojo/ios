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
import UIKit
import SwiftHEXColors

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
        let url100: String?
        let url500: String?
        
        func isPresent() -> Bool {
            return dominantColor != nil && url500 != nil
        }
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
            <*> j <|? "artwork-url-100"
            <*> j <|? "artwork-url-500"
    }
}

// FIXME: Consider placing this extension elsewhere
extension NowPlayingInfo.Artwork {
    func dominantUIColor() -> UIColor? {
        guard let colorStr = dominantColor else { return nil }
        return UIColor(hexString: colorStr)
    }
}
