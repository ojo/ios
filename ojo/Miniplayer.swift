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

    init(_ navigationController: UINavigationController,
         playbackManager: PlaybackManager) {
        root = navigationController
        self.playbackManager = playbackManager
        self.playbackManager.addDelegate(self)
    }
    
    func didChangeState(_ s: PlaybackState) {
        switch s {
        case .buffering: break
        case .started: break
        case .stopped: break
        }
    }
    
    func incoming(info: NowPlayingInfo) {
        // TODO(btc): Impl
    }

    func showMiniplayer() {
        let vc = NowPlayingViewController(playbackManager: playbackManager)
        root?.presentPopupBar(withContentViewController: vc,
                              animated: true,
                              completion: nil)
    }
    
    func hideMiniplayer() {
        root?.dismissPopupBar(animated: true, completion: nil)
    }
}
