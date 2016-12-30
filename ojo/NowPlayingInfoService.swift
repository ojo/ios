//
//  NowPlayingInfoService.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/30/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Alamofire
import Foundation

class NowPlayingInfoService {
    
    let API_URL = "https://api.ojo.world/api/v0/stations/now-playing"
    
    init() {
    }
    
    func request(forStation station: Station,
                 callback: (NowPlayingInfo) -> Void) {
        print("request!")
        let p = ["tag": station.tag]
        Alamofire.request(API_URL, parameters: p).responseJSON { response in
            if let json = response.result.value {
                // convert to NPI and call the callback
            }
        }
    }
    
    func subscribe(forStation station: Station,
                   callback: (NowPlayingInfo) -> Void) {
        // TODO
    }
    
    func unsubscribe(forStation station: Station) {
        // TODO
    }
}
