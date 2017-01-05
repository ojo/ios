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
    
    // NB(btc): svarlasses NSObject in order to perform KVO on player
    
    private let PLAYER_ITEM_KEYPATHS = [
        "playbackBufferEmpty",
        "playbackLikelyToKeepUp",
        "playbackBufferFull",
        ]
  
    private let player = AVPlayer()
    
    private var delegates = [PlaybackDelegate]()
    
    private var infoService = NowPlayingInfoService()

    private let remoteControlResponder = RemoteControlResponder()
    
    // |nowPlayingInfo| is nil if station is nil
    private(set) var nowPlayingInfo: NowPlayingInfo? = nil {
        didSet {
            guard let s = station else { return }
            delegates.forEach {
                $0.incoming(info: nowPlayingInfo ?? s.info(), forStation: s)
            }
        }
    }
    
    private(set) var state: PlaybackState = .stopped {
        didSet {
            switch state {
            case .buffering:
                delegates.forEach() { $0.didChange(state: .buffering) }
                guard let s = station else {
                    print("station should not be nil in buffering state")
                    return
                }
                // TODO perhaps this needs to be moved to the clients where it'll be
                // their responsibility to get the information they need. this feels
                // weird to do here.
                delegates.forEach() { $0.incoming(info: nowPlayingInfo ?? s.info(), forStation: s) }
            case .started:
                delegates.forEach() { $0.didChange(state: .started) }
            case .stopped:
                delegates.forEach() { $0.didChange(state: .stopped) }
            }
        }
    }
    
    var station: Station? = nil {
        
        willSet {
            if let currentStation = station, let nextStation = newValue,
                currentStation.isEqual(to: nextStation) {
                // if current and next both exist and they are the same, don't
                // run these operations
                return
            }

            PLAYER_ITEM_KEYPATHS.forEach() {
                player.currentItem?.removeObserver(self, forKeyPath: $0)
            }
            if let station = station {
                infoService.unsubscribe(from: station)
            }
        }
        didSet {
            guard let station = station else {
                nowPlayingInfo = nil
                return
            }
            
            // because of the above guard, we know that station is now present.
            // if the old value of the optional was also a station, and they 
            // were the same, then don't execute these operations
            
            if let oldValue = oldValue, station.isEqual(to: oldValue) {
                return
            }
            
            state = .stopped
            
            // station changed (old value might have been nil)
            
            let nextItem = AVPlayerItem(url: station.url)
            
            PLAYER_ITEM_KEYPATHS.forEach() {
                nextItem.addObserver(self,
                                     forKeyPath: $0,
                                     options: .new,
                                     context: nil)
            }
            infoService.request(infoFor: station,
                                callback: incomingNowPlayingInfo)
            infoService.subscribe(to: station,
                                  callback: incomingNowPlayingInfo)
            player.replaceCurrentItem(with: nextItem)
        }
    }
    
    convenience init(infoService: NowPlayingInfoService) {
        self.init()
        self.infoService = infoService
    }
    
    override init() {
        super.init()
        
        // beginReceivingRemote... is required in order to resume playback after
        // intermittent interruption. for some reason, handling interruptions
        // doesn't work otherwise.
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        remoteControlResponder.add(delegate: self)
        
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(self.handleInterruption),
                         name: .AVAudioSessionInterruption,
                         object: nil)
        player.addObserver(self,
                           forKeyPath: "status",
                           options: .new,
                           context: nil)
        player.addObserver(self,
                           forKeyPath: "rate",
                           options: .new,
                           context: nil)
        
        delegates.append(InfoCenterDelegate())
    }
    
    func addDelegate(_ d: PlaybackDelegate) {
        delegates.append(d)
    }
    
    func play() {
        prepareAudioPlaybackForBackgrounding()
        player.play()
    }
    
    func stop() {
        player.pause()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        switch object {
        case let p as AVPlayer where p == player:
            guard let keyPath = keyPath else { return }
            switch keyPath {
            case "status": break
            case "rate":
                state = player.rate == 0 ? .stopped : .started
            default: break
            }
        case is AVPlayerItem:
            guard let keyPath = keyPath else { return }
            switch keyPath {
            case "playbackBufferEmpty":
                state = .buffering
            case "playbackLikelyToKeepUp":
                state = .started
            default: break
            }
        default: break
        }
    }
    
    private func incomingNowPlayingInfo(info: NowPlayingInfo) {
        
        // only proceed if there is a current station
        guard let station = station else { return }
        // ignore stale data
        guard info.stationTag == station.tag else { return }
        // make sure this info is current
        guard !info.expired() else { return }
        
        // set the value BEFORE notifying delegates
        nowPlayingInfo = info
        
        // invalidate info if it's still around after expiry!
        guard info.expires() else { return }
        info.onExpiry().then { _ -> Void in
            
            // if there's no currentInfo, there's no point in doing anything else
            guard let currentInfo = self.nowPlayingInfo else { return }
            
            if currentInfo == info {
                // then it's time to say goodbye
                self.nowPlayingInfo = nil
            }
        }.catch { _ in
            print("tried to listen for expiry on a value that doesn't expire")
        }
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
