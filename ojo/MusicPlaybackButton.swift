//
//  MusicPlaybackButton.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

// TODO rename PlaybackToggleButton
class MusicPlaybackButton : UIButton {
    
    static public let playImage: UIImage = UIImage(named: "play")!
    static public let pauseImage: UIImage = UIImage(named: "pause")!
    
    var playbackState = PlaybackState.stopped {
        didSet {
            switch playbackState {
            case .buffering:
                bringSubview(toFront: spinner)
                setImage(nil, for: .normal)
                spinner.startAnimating()
            case .stopped:
                spinner.stopAnimating()
                setImage(MusicPlaybackButton.playImage, for: .normal)
            case .started:
                spinner.stopAnimating()
                setImage(MusicPlaybackButton.pauseImage, for: .normal)

            }
        }
    }
    
    private let spinner: UIActivityIndicatorView = {
        let result = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        result.hidesWhenStopped = true
        return result
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView?.contentMode = .scaleAspectFit
        
        // it's unclear to me why this is required to make the damn thing work.
        sizeToFit()
        
        spinner.startAnimating()
        
        addSubview(spinner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let scX = bounds.width / 2
        let scY = bounds.height / 2
        spinner.center = CGPoint(x: scX, y: scY)
    }
}
