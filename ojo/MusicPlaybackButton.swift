//
//  MusicPlaybackButton.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class MusicPlaybackButton : UIButton {
    
    var playbackState = PlaybackState.stopped
    
    static public let playImage: UIImage = UIImage(named: "play")!
    static public let pauseImage: UIImage = UIImage(named: "pause")!
    static public let bufferingImage: UIImage = UIImage(named: "radio")!
    
    func buffering() {
        playbackState = .buffering
        setImage(MusicPlaybackButton.bufferingImage, for: .normal)
    }
    
    func playing() {
        playbackState = .started
        setImage(MusicPlaybackButton.pauseImage, for: .normal)
    }
    
    func stopped() {
        playbackState = .stopped
        setImage(MusicPlaybackButton.playImage, for: .normal)
    }
}
