//
//  InfoCenterDelegate.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/2/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import MediaPlayer

class InfoCenterDelegate: PlaybackDelegate {
    
    func incoming(info: NowPlayingInfo?, forStation station: Station) {
        guard let info = info else { return }
        var image: UIImage = station.image // default
        
        if info.artwork.isPresent(),
            let c = info.artwork.dominantUIColor(),
            let url = info.artwork.url500 {
            
            // potentially replace image with a colored image
            let size = CGSize(width: 1, height: 1)
            if let colorImage = UIImage.from(color: c, withSize: size) {
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
    
    private func updateInfoCenter(withInfo info: NowPlayingInfo?,
                                  andImage image: UIImage) {
        guard let info = info else { return } // TODO handle empty info state
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: info.title,
            MPMediaItemPropertyArtist: info.artist,
            MPMediaItemPropertyAlbumTitle: info.album,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: image),
        ]
    }
}
