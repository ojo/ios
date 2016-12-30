//
//  PlaybackManager.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import AVFoundation
import Foundation

// NB(btc): not thread-safe.
class PlaybackManager : NSObject { // NB(btc): subclassed in order to perform KVO on player
  
    lazy var player = AVPlayer()
    
    var delegate: PlaybackManagerDelegate?
    
    override init() {
        super.init()
        
        prepareAudioPlaybackForBackgrounding()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.handleInterruption),
                                               name: .AVAudioSessionInterruption,
                                               object: nil)
        player.addObserver(self,
                           forKeyPath: "status",
                           options: .new,
                           context: nil)
    }
    
    public func setURL(_ url: URL) {
        let nextItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: nextItem)
    }
    
    public func play() {
        player.play()
    }
    
    public func stop() {
        player.pause()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        switch object {
        case let p as AVPlayer:
            if p == player && keyPath == "status" {
                // TODO(btc): handle player status change
            }
        default:
            break
        }
    }
    
    @objc private func handleInterruption(n: NSNotification) {
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
    
    private func prepareAudioPlaybackForBackgrounding() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}

// FIXME(btc): put enum and delegate in separate files?

enum PlaybackState {
    case Started
    case Stopped
    case Buffering
}

protocol PlaybackManagerDelegate {
    func playbackDidChangeState(_ s: PlaybackState)
}
