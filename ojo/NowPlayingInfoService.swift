//
//  NowPlayingInfoService.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/30/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Alamofire
import UIKit
import Argo

class NowPlayingInfoService {

    typealias Callback = (NowPlayingInfo, Future<UIImage>) -> Void

    let API_URL = "https://api.ojo.world/api/v0/stations/now-playing"

    init() {
    }

    func request(infoFor station: Station,
                 callback: @escaping Callback) {
        let p = ["tag": station.tag]
        Alamofire.request(API_URL, parameters: p).responseJSON { response in
            if let json: Any = response.result.value {
                if let info = NowPlayingInfoService.AnyToInfo(json) {
                    let f = Future<UIImage>()
                    callback(info, f)
                }
            }
        }
    }

    func subscribe(to station: Station,
                   callback: Callback) {
        // TODO
    }

    func unsubscribe(from station: Station) {
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
