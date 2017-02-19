//
//  Miniplayer.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/29/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit
import LNPopupController
import Reachability

class Miniplayer {
    
    fileprivate var playbackManager: PlaybackManager
    
    // one alternative to holding a reference to this controller is to use the 
    // delegate pattern to tell the delegate when to display the miniplayer.
    // that seems less preferable because of the interobject communication.
    // however, holding the property like this is undesirable because of the
    // circular reference between root <-> miniplayer
    fileprivate var barPresenter: UIViewController?
    
    fileprivate var nowPlaying: NowPlayingViewController
    
    fileprivate var playbackToggle: PlaybackToggleButton = {
        let result = PlaybackToggleButton()
        return result
    }()
    
    fileprivate let net = Reachability()!

    init(_ barPresenter: UIViewController,
         playbackManager: PlaybackManager) {

        self.barPresenter = barPresenter
        self.playbackManager = playbackManager
        self.nowPlaying = NowPlayingViewController(playbackManager: playbackManager)
        self.playbackManager.addObserver(self)
        
        self.barPresenter?.popupBar.marqueeScrollEnabled = true
        
        playbackToggle.addTarget(self,
                                 action: #selector(toggled),
                                 for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: playbackToggle)
        self.nowPlaying.popupItem.rightBarButtonItems = [buttonItem]
        
        try? net.startNotifier()
        net.whenUnreachable = { _ in
            DispatchQueue.main.async {
                if playbackManager.state != .started {
                    self.hideMiniplayer()
                }
            }
        }
    }
    
    func showMiniplayer() {
        guard net.currentReachabilityStatus != .notReachable else { return }
        if let state = barPresenter?.popupPresentationState, state == .hidden {
            barPresenter?.presentPopupBar(withContentViewController: nowPlaying,
                                          animated: true,
                                          completion: nil)
        }
    }
    
    func hideMiniplayer() {
        barPresenter?.dismissPopupBar(animated: true, completion: nil)
    }
    
    @objc private func toggled() {
        // It is a UX decision to always respect the appearance of the toggle 
        // even if it goes out of sync with the internal state. This way, the user
        // always has control of the playback 
        switch playbackToggle.playbackState {
        case .stopped:
            playbackManager.play()
        case .started:
            playbackManager.stop()
        case .buffering: break
        }
    }
}

extension Miniplayer: PlaybackObserver {
    
    func didChange(state: PlaybackState) {
        playbackToggle.playbackState = state
        switch state {
        case .buffering:
            switch net.currentReachabilityStatus {
            case .notReachable:
                hideMiniplayer()
            default:
                // because either music is about to play or has temporarily stalled
                showMiniplayer()
            }
        case .started:
            showMiniplayer()
        case .stopped:
            if net.currentReachabilityStatus == .notReachable {
                // When music has stopped and the user is offline, the miniplayer
                // becomes a false affordance.
                // https://en.wikipedia.org/wiki/Affordance#False_affordances
                hideMiniplayer()
            }
        }
    }
    
    func incoming(info: NowPlayingInfo, forStation station: Station) {
        let p = TwoLinePresenter(forInfo: info)
        nowPlaying.popupItem.title = p.title
        nowPlaying.popupItem.subtitle = p.subtitle
        if info.artwork.isPresent(),
            let color = info.artwork.dominantUIColor(),
            let url = info.artwork.url100 {
            
            let colorImage = UIImage.from(color: color)
            nowPlaying.popupItem.image = colorImage
            
            UIImage.promise(url: url).then { image in
                self.nowPlaying.popupItem.image = image
                }.catch { _ in
                    self.nowPlaying.popupItem.image = station.image
            }
        } else {
            nowPlaying.popupItem.image = playbackManager.station?.image
        }
    }
}
