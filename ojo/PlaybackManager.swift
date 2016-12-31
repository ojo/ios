//
//  PlaybackManager.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

// NB(btc): not thread-safe.
class PlaybackManager : NSObject, RemoteControlDelegate {
    
    // NB(btc): subclasses NSObject in order to perform KVO on player
    
    private let PLAYER_ITEM_KEYPATHS = [
        "playbackBufferEmpty",
        "playbackLikelyToKeepUp",
        "playbackBufferFull",
        ]
  
    let player = AVPlayer()
    
    var delegates = [PlaybackDelegate]()
    
    let infoService = NowPlayingInfoService()


    let remoteControlResponder = RemoteControlResponder()
    
    var station: Station? = nil {
        
        willSet(newStation) {
            PLAYER_ITEM_KEYPATHS.forEach({
                player.currentItem?.removeObserver(self, forKeyPath: $0)
            })
            if let station = station {
                infoService.unsubscribe(station: station)
            }
        }
        
        didSet {
            guard let station = station else { return }
            
            let nextItem = AVPlayerItem(url: station.url)
            
            PLAYER_ITEM_KEYPATHS.forEach({
                nextItem.addObserver(self,
                                     forKeyPath: $0,
                                     options: .new,
                                     context: nil)
            })
            infoService.request(station: station,
                               callback: incomingNowPlayingInfo)
            infoService.subscribe(station: station,
                                 callback: incomingNowPlayingInfo)
            player.replaceCurrentItem(with: nextItem)
        }
    }
    
    override init() {
        super.init()
        
        // beginReceivingRemote... is required in order to resume playback after
        // intermittent interruption. for some reason, handling interruptions
        // doesn't work otherwise.
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        remoteControlResponder.add(delegate: self)
        
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
    
    public func addDelegate(_ d: PlaybackDelegate) {
        delegates.append(d)
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
    
    private func incomingNowPlayingInfo(info: NowPlayingInfo) {
        
        // only proceed if there is a current station
        guard let station = station else { return }
        // ignore stale data
        guard info.stationTag == station.tag else { return }
        
        for d in delegates {
            d.incoming(info: info)
        }
        
        // TODO update MPNowPlaying...
    }
    
    @objc private func handleInterruption(n: NSNotification) {
        guard n.name == .AVAudioSessionInterruption else { return }
        guard let y = n.userInfo?[AVAudioSessionInterruptionTypeKey]
            as? NSNumber else { return }

        let began = NSNumber(value: AVAudioSessionInterruptionType.began.rawValue)
        let ended = NSNumber(value: AVAudioSessionInterruptionType.ended.rawValue)
        if y.isEqual(to: began) {
            stop()
        } else if y.isEqual(to: ended) {
            play()
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
    
    func received(eventType: UIEventSubtype) {
        switch eventType {
        case .remoteControlPlay:
            play()
        case .remoteControlPause:
            stop()
        default: break
            // TODO(btc): handle next, prev
        }
    }
}

// FIXME(btc): put enum and delegate in separate files?

enum PlaybackState {
    case started
    case stopped
    case buffering
}

protocol PlaybackDelegate {
    func didChangeState(_ state: PlaybackState)
    func incoming(info: NowPlayingInfo)
}
