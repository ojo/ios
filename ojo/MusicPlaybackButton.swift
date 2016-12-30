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
    static public let playImage: UIImage = UIImage(named: "play")!
    static public let pauseImage: UIImage = UIImage(named: "pause")!
    static public let bufferingImage: UIImage = UIImage(named: "radio")!
    
    func buffering() {
        setImage(MusicPlaybackButton.bufferingImage, for: .normal)
    }
    
    func playing() {
        setImage(MusicPlaybackButton.pauseImage, for: .normal)
    }
    
    func stopped() {
        setImage(MusicPlaybackButton.playImage, for: .normal)
    }
}
