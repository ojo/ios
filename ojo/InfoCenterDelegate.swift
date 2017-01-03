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
        var image: UIImage = station.image
        if info.artwork.isPresent(), let c = info.artwork.dominantUIColor() {
            let size = CGSize(width: 1, height: 1)
            if let colorImage = UIImage.from(color: c, withSize: size) {
                image = colorImage
            }
            // TODO asynchronously fetch artwork
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: info.title,
            MPMediaItemPropertyArtist: info.artist,
            MPMediaItemPropertyAlbumTitle: info.album,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: image),
        ]
    }
    
    func didChange(state: PlaybackState) {
    }
}
