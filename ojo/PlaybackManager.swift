//
//  PlaybackManager.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import AVFoundation
import Foundation

// TODO(btc): need lock?

class PlaybackManager : NSObject { // NB(btc): subclassed in order to perform KVO on player
    lazy var player = AVPlayer()
    var stationManager: StationManager
    var delegate: PlaybackManagerDelegate?
    
    init(stationManager: StationManager) {
        self.stationManager = stationManager

        super.init()
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleInterruption),
                                               name: .AVAudioSessionInterruption,
                                               object: nil)
        player.addObserver(self,
                           forKeyPath: "status",
                           options: NSKeyValueObservingOptions(rawValue: 0),
                           context: nil)
    }
    
    public func play() {
        player.play()
    }
    
    public func stop() {
        player.pause()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            // TODO(btc): handle player status change
        }
    }
    
    func handleInterruption(n: NSNotification) {
        if n.name == .AVAudioSessionInterruption {
            switch n.userInfo![AVAudioSessionInterruptionTypeKey]! {
            case AVAudioSessionInterruptionType.began:
                stop()
            case AVAudioSessionInterruptionType.ended:
                play()
            default:
                break
            }
        }
    }
}

enum PlaybackState {
    case Started
    case Stopped
    case Buffering
}

protocol PlaybackManagerDelegate {
    func playbackDidChangeState(_ s: PlaybackState)
}
