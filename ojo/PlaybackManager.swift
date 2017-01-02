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
import MediaPlayer

// NB(btc): not thread-safe.
class PlaybackManager : NSObject, RemoteControlDelegate {
    
    // NB(btc): subclasses NSObject in order to perform KVO on player
    
    private let PLAYER_ITEM_KEYPATHS = [
        "playbackBufferEmpty",
        "playbackLikelyToKeepUp",
        "playbackBufferFull",
        ]
  
    private let player = AVPlayer()
    
    private var delegates = [PlaybackDelegate]()
    
    private let infoService = NowPlayingInfoService()


    private let remoteControlResponder = RemoteControlResponder()
    
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
            guard let station = station else { return }
            
            // because of the above guard, we know that station is now present.
            // if the old value of the optional was also a station, and they 
            // were the same, then don't execute these operations
            
            if let oldValue = oldValue, station.isEqual(to: oldValue) {
                return
            }
            
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
    }
    
    func addDelegate(_ d: PlaybackDelegate) {
        delegates.append(d)
    }
    
    func play() {
        print(player.status)
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
        case let p as AVPlayer:
            if p == player && keyPath == "status" {
                // TODO(btc): handle player status change
            }
        case let item as AVPlayerItem:
            guard let keyPath = keyPath else { return }
            switch keyPath {
            case "playbackBufferEmpty":
                delegates.forEach() { $0.didChange(state: .buffering) }
            case "playbackLikelyToKeepUp":
                delegates.forEach() { $0.didChange(state: .started) }
            default:
                // TODO(btc): remove these debug prints
                print("unhandled observation: \(keyPath)")
                print(keyPath)
                print(item.status.rawValue)
            }
        default:
            break
        }
    }
    
    private func incomingNowPlayingInfo(info: NowPlayingInfo, future: Future<UIImage>) {
        
        // only proceed if there is a current station
        guard let station = station else { return }
        // ignore stale data
        guard info.stationTag == station.tag else { return }
        
        for d in delegates {
            d.incoming(info: info, future: future)
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: info.title,
            MPMediaItemPropertyArtist: info.artist,
            MPMediaItemPropertyAlbumTitle: info.album,
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: station.image),
        ]
        // TODO asynchronously fetch artwork
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
    func didChange(state: PlaybackState)
    func incoming(info: NowPlayingInfo, future: Future<UIImage>)
}
