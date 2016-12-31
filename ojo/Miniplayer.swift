//
//  Miniplayer.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/29/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit

class Miniplayer: PlaybackDelegate {
    
    private var playbackManager: PlaybackManager
    
    private var root: UINavigationController?
    
    private var nowPlaying: NowPlayingViewController

    init(_ navigationController: UINavigationController,
         playbackManager: PlaybackManager) {
        self.root = navigationController
        self.playbackManager = playbackManager
        self.nowPlaying = NowPlayingViewController(playbackManager: playbackManager)
        self.playbackManager.addDelegate(self)
    }
    
    func didChange(state: PlaybackState) {
        switch state {
        case .buffering:
            // TODO(btc): update playback toggle to reflect buffering state
            showMiniplayer()
        case .started:
            // TODO(btc): update playback toggle to pause/stop button
            showMiniplayer()
        case .stopped: break
        }
    }
    
    func incoming(info: NowPlayingInfo) {
        
        if info.title == "" {
            // then the server hasn't been fixed yet.
            nowPlaying.popupItem.title = info.artist
            nowPlaying.popupItem.subtitle = info.album
        } else {
            nowPlaying.popupItem.title = info.title
            nowPlaying.popupItem.subtitle = info.artist
        }
        
        // replace station image with info.artwork.image when it loads async'ly
        // change the contentMode of the imageView so that the station image
        // isn't distorted
        nowPlaying.popupItem.image = playbackManager.station?.image
        // TODO(btc): nowPlaying?.popupItem.image = future.result
    }

    func showMiniplayer() {
        root?.presentPopupBar(withContentViewController: nowPlaying,
                              animated: true,
                              completion: nil)
    }
    
    func hideMiniplayer() {
        root?.dismissPopupBar(animated: true, completion: nil)
    }
}
