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

let Stations: [Station] = [
    Station(
        title: "STAR",
        url: NSURL(string: "http://fms.ttrn.org:1936/live/star947.sdp/playlist.m3u8")!,
        tag: "947fm",
        image: UIImage(named: "947fm")!
        ),
    Station(
        title: "WEFM",
        url: NSURL(string: "http://fms.ttrn.org:1936/live/961wefm.sdp/playlist.m3u8")!,
        tag: "961fm",
        image: UIImage(named: "961fm")!
    ),
    Station(
        title: "Music for Life",
        url: NSURL(string: "http://fms.ttrn.org:1936/live/1077fm.sdp/playlist.m3u8")!,
        tag: "1077fm",
        image: UIImage(named: "1077fm")!
    ),
]

struct Station {
    var title: String
    var url: NSURL
    var tag: String
    var image: UIImage
}
