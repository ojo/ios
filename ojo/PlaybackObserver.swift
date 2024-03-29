//
//  PlaybackDelegate.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/1/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

protocol PlaybackObserver {
    func didChange(state: PlaybackState)
    func incoming(info: NowPlayingInfo, forStation station: Station)
}
