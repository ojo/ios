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

    struct Artwork {
        let artworkDominantColor: String?
        let artworkUrl500: String?
    }
}
