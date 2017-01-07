//
//  PlaybackInterruptionHandler.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/7/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit
import AVFoundation

class PlaybackInterruptionHandler: NSObject {
    
    var wasPlayingBeforeInterruption = false
    
    weak var playbackManager: PlaybackManager?
    
    init(_ playbackManager: PlaybackManager) {
        super.init()
        self.playbackManager = playbackManager
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(self.handleInterruption),
                         name: .AVAudioSessionInterruption,
                         object: nil)
    }
    
    @objc private func handleInterruption(n: NSNotification) {
        guard let playbackManager = playbackManager else { return }
        guard n.name == .AVAudioSessionInterruption else { return }
        guard let y = n.userInfo?[AVAudioSessionInterruptionTypeKey]
            as? NSNumber else { return }
        
        let began = NSNumber(value: AVAudioSessionInterruptionType.began.rawValue)
        let ended = NSNumber(value: AVAudioSessionInterruptionType.ended.rawValue)
        if y.isEqual(to: began) {
            switch playbackManager.state {
            case .started, .buffering:
                playbackManager.stop()
                wasPlayingBeforeInterruption = true
            case .stopped:
                wasPlayingBeforeInterruption = false
            }
        } else if y.isEqual(to: ended) {
            if wasPlayingBeforeInterruption {
                playbackManager.play()
            }
            wasPlayingBeforeInterruption = false
        }
    }
}
