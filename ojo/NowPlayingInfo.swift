//
//  NowPlayingInfo.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/29/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

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
