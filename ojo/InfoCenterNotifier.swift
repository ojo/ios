//
//  InfoCenterDelegate.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/2/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import MediaPlayer

class InfoCenterNotifier: PlaybackObserver {
    
    func incoming(info: NowPlayingInfo, forStation station: Station) {
        var image: UIImage = station.image // default
        
        if info.artwork.isPresent(),
            let c = info.artwork.dominantUIColor(),
            let url = info.artwork.url500 {
            
            // potentially replace image with a colored image
            let size = CGSize(width: 1, height: 1)
            if let colorImage = UIImage.from(color: c) {
                image = colorImage
            }
            
            // then fetch the real image from the network
            fetchImage(url).then { fetched in
                self.updateInfoCenter(withInfo: info, andImage: fetched)
            }.catch { err in // fallback
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
