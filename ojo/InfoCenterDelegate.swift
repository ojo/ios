//
//  InfoCenterDelegate.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/2/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import MediaPlayer

class InfoCenterDelegate: PlaybackDelegate {
    func incoming(info: NowPlayingInfo, forStation station: Station) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: info.title,
            MPMediaItemPropertyArtist: info.artist,
            MPMediaItemPropertyAlbumTitle: info.album,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: station.image),
        ]
        // TODO asynchronously fetch artwork
    }
    
    func didChange(state: PlaybackState) {
    }
}
