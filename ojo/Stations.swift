//
//  Stations.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/25/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

// TODO(btc): Add named image assets

let STATIONS: [Station] = [
    Station(
        title: "STAR",
        url: URL(string: "http://fms.ttrn.org:1936/live/star947.sdp/playlist.m3u8")!,
        tag: "947fm",
        image: UIImage(named: "947fm")!
        ),
    Station(
        title: "WEFM",
        url: URL(string: "http://fms.ttrn.org:1936/live/961wefm.sdp/playlist.m3u8")!,
        tag: "961fm",
        image: UIImage(named: "961fm")!
    ),
    Station(
        title: "Music for Life",
        url: URL(string: "http://fms.ttrn.org:1936/live/1077fm.sdp/playlist.m3u8")!,
        tag: "1077fm",
        image: UIImage(named: "1077fm")!
    ),
]

struct Station {
    let title: String // the name the user sees
    let url: URL
    let tag: String // a key used to identify the station when making station-specfic API calls
    let image: UIImage
    
    func isEqual(to station: Station) -> Bool {
        return tag == station.tag
    }
}
