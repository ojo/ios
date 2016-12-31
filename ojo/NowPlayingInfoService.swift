//
//  NowPlayingInfoService.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/30/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Alamofire
import Argo
import Curry
import Runes

class NowPlayingInfoService {

    let API_URL = "https://api.ojo.world/api/v0/stations/now-playing"

    init() {
    }

    func request(station: Station,
                 callback: @escaping (NowPlayingInfo) -> Void) {
        let p = ["tag": station.tag]
        Alamofire.request(API_URL, parameters: p).responseJSON { response in
            if let json: Any = response.result.value {
                if let info = NowPlayingInfoService.AnyToInfo(json) {
                    callback(info)
                }
            }
        }
    }

    func subscribe(station: Station,
                   callback: (NowPlayingInfo) -> Void) {
        // TODO
    }

    func unsubscribe(station: Station) {
        // TODO
    }

    private static func AnyToInfo(_ data: Any) -> NowPlayingInfo? {
        let decoded: Decoded<NowPlayingInfo> = JSON(data) <| ["data", "attributes"]
        if let info = decoded.value {
            return info
        }
        // TODO(btc): debug print only
        print(decoded.error.debugDescription)
        return nil
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
