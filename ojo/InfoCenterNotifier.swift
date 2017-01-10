//
//  InfoCenterDelegate.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/2/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import MediaPlayer

class InfoCenterNotifier: PlaybackObserver {
    
    var current: NowPlayingInfo?
    
    func incoming(info: NowPlayingInfo, forStation station: Station) {
        current = info
        var image: UIImage = station.image // default
        
        if info.artwork.isPresent(),
            let c = info.artwork.dominantUIColor(),
            let url = info.artwork.url500,
            let colorImage = UIImage.from(color: c) {
            
            image = colorImage
            
            // then fetch the real image from the network
            fetchImage(url).then { fetched -> Void in
                guard let c = self.current, info == c else { return }
                self.updateInfoCenter(withInfo: info, andImage: fetched)
            }.catch { err in // fallback
                guard let c = self.current, info == c else { return }
                self.updateInfoCenter(withInfo: info, andImage: station.image)
            }
        }
        updateInfoCenter(withInfo: info, andImage: image)
    }
    
    func didChange(state: PlaybackState) {
    }
    
    private func updateInfoCenter(withInfo info: NowPlayingInfo,
                                  andImage image: UIImage) {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: info.title,
            MPMediaItemPropertyArtist: info.artist,
            MPMediaItemPropertyAlbumTitle: info.album,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: image),
        ]
    }
}
