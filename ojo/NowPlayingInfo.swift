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
import PromiseKit
import SwiftHEXColors

// NB: Artwork...
// is embedded as another struct because of a limitation in the curry lib
// see: https://github.com/thoughtbot/Argo/blob/master/Documentation/Curry-Limitations.md

struct NowPlayingInfo {
    let title: String
    let artist: String
    let album: String
    let stationTag: String
    let mediaType: String
    
    let startedAt: Int?
    let lengthInSecs: Int?
    
    let artwork: Artwork

    
    struct Artwork {
        let dominantColor: String?
        let url100: String?
        let url500: String?
        
        func isPresent() -> Bool {
            return dominantColor != nil && url500 != nil
        }
    }
}

extension NowPlayingInfo {
    static func ==(lhs: NowPlayingInfo, rhs: NowPlayingInfo) -> Bool {
        
        // In practice, we really don't need to check every field to know that
        // two infos are the same. Still, it's good to be safe. Consider this
        // safe. Even as we add new fields, it's probably not necessary to update
        // this every time.
        return lhs.title == rhs.title &&
            lhs.artist == rhs.artist &&
            lhs.album == rhs.album &&
            lhs.stationTag == rhs.stationTag &&
            lhs.mediaType == rhs.mediaType &&
            lhs.startedAt == rhs.startedAt &&
            lhs.lengthInSecs == rhs.lengthInSecs
    }
}

extension NowPlayingInfo {
    
    enum Err: Error {
        case neverExpires
    }
    
    func expires() -> Bool {
        return startedAt != nil && lengthInSecs != nil
    }
    
    func expired() -> Bool {
        guard let e = expiry() else { return false }
        return e < Date()
    }
    
    func expiry() -> Date? {
        guard let s = startedAt, let l = lengthInSecs else { return nil }
        let expiry: Int = s + l + ESTIMATED_STREAM_LATENCY_IN_SECS
        let ti: TimeInterval = Double(expiry)
        return Date(timeIntervalSince1970: ti)
    }
    
    func onExpiry() -> Promise<Void> {
        guard expires() else {
            return Promise(error: Err.neverExpires)
        }
        return Promise { fulfill, reject in
            guard let e = expiry() else { reject(Err.neverExpires); return }
            let interval = e.timeIntervalSinceNow
            let when = DispatchTime.now() + interval
            DispatchQueue.main.asyncAfter(deadline: when, execute: fulfill)
        }
    }
}

func either<T: Decodable>(_ j: JSON, _ field: String, _ alt: String) -> Decoded<T> where T == T.DecodedType {
    return j <| field <|> j <| alt
}

func eitherO<T: Decodable>(_ j: JSON, _ field: String, _ alt: String) -> Decoded<T?> where T == T.DecodedType {
    return  j <|? field <|> j <|? alt
}

extension NowPlayingInfo: Decodable {
    static func decode(_ j: JSON) -> Decoded<NowPlayingInfo> {
        return curry(self.init)
            <^> j <| "title"
            <*> j <| "artist"
            <*> j <| "album"
            <*> either(j, "station-tag", "station_tag")
            <*> either(j, "media-type", "media_type")
            <*> eitherO(j, "started-at", "started_at")
            <*> eitherO(j, "length-in-secs", "length_in_secs")
            <*> NowPlayingInfo.Artwork.decode(j)
    }
}

extension NowPlayingInfo.Artwork: Decodable {
    static func decode(_ j: JSON) -> Decoded<NowPlayingInfo.Artwork> {
        return curry(self.init)
            <^> eitherO(j, "artwork-dominant-color", "artwork_dominant_color")
            <*> eitherO(j, "artwork-url-100",  "artwork_url_100")
            <*> eitherO(j, "artwork-url-500", "artwork_url_500")
    }
}

// FIXME: Consider placing this extension elsewhere
extension NowPlayingInfo.Artwork {
    func dominantUIColor() -> UIColor? {
        guard let colorStr = dominantColor else { return nil }
        return UIColor(hexString: colorStr)
    }
}
