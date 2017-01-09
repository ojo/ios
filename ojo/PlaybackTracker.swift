//
//  PlaybackTracker.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/1/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

final class PlaybackTracker: PlaybackObserver {
    
    private let analytics: Analytics
    private let playbackManager: PlaybackManager
    
    private var lastPlaybackState: PlaybackState?
    
    private init(analytics: Analytics, playbackManager: PlaybackManager) {
        self.analytics = analytics
        self.playbackManager = playbackManager
    }
    
    static func bind(analytics: Analytics, playbackManager: PlaybackManager) {
        let proxy = PlaybackTracker(analytics: analytics,
                                    playbackManager: playbackManager)
        playbackManager.addObserver(proxy)
    }
    
    func incoming(info: NowPlayingInfo, forStation station: Station) { /* nop */ }
    
    func didChange(state: PlaybackState) {
        switch state {
        case .buffering: break
        // TODO decide what to do about this event. We only care about buffering
        // if previous state was .started
        case .started:
            if let station = playbackManager.station,
                lastPlaybackState != .started {
                
                // FIXME: if we go from started to buffering to started, the listening
                // session gets reset.
                analytics.trackListeningSessionBegin(station: station)
            }
        case .stopped:
            analytics.trackListeningSessionEnd()
            // we need to be sure we actually catch the end session notification
        }
        lastPlaybackState = state
    }
}
