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
    
    // one alternative to holding a reference to this controller is to use the 
    // delegate pattern to tell the delegate when to display the miniplayer.
    // that seems less preferable because of the interobject communication.
    // however, holding the property like this is undesirable because of the
    // circular reference between root <-> miniplayer
    private var barPresenter: UIViewController?
    
    private var nowPlaying: NowPlayingViewController
    
    private var playbackToggle: MusicPlaybackButton = {
        let result = MusicPlaybackButton()
        return result
    }()

    init(_ barPresenter: UIViewController,
         playbackManager: PlaybackManager) {
        self.barPresenter = barPresenter
        self.playbackManager = playbackManager
        self.nowPlaying = NowPlayingViewController(playbackManager: playbackManager)
        self.playbackManager.addDelegate(self)
        
        self.barPresenter?.popupBar.marqueeScrollEnabled = true
        
        playbackToggle.addTarget(self,
                                 action: #selector(toggled),
                                 for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: playbackToggle)
        self.nowPlaying.popupItem.rightBarButtonItems = [buttonItem]
    }
    
    func didChange(state: PlaybackState) {
        playbackToggle.playbackState = state
        switch state {
        case .buffering:
            showMiniplayer()
        case .started:
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
        if info.artwork.isPresent(), let color = info.artwork.dominantUIColor() {
            let size = CGSize(width: 100, height: 100) // an educated guess.
            let colorImage = UIImage.from(color: color, withSize: size)
            nowPlaying.popupItem.image = colorImage
        } else {
            nowPlaying.popupItem.image = playbackManager.station?.image
        }
    }

    private func showMiniplayer() {
        if let state = barPresenter?.popupPresentationState, state == .hidden {
            barPresenter?.presentPopupBar(withContentViewController: nowPlaying,
                                          animated: true,
                                          completion: nil)
            // TODO: fetch nowPlayingInfo
        }
    }
    
    @objc func toggled() {
        switch playbackToggle.playbackState {
        case .stopped:
            playbackManager.play()
        case .started:
            playbackManager.stop()
        case .buffering: break
        }
    }
}
