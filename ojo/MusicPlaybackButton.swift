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
    
    var playbackState = PlaybackState.stopped {
        didSet {
            switch playbackState {
            case .buffering:
                imageView?.isHidden = true
                spinner.startAnimating()
                bringSubview(toFront: spinner)
            case .stopped:
                spinner.stopAnimating()
                imageView?.isHidden = false
                setImage(MusicPlaybackButton.playImage, for: .normal)
            case .started:
                spinner.stopAnimating()
                imageView?.isHidden = false
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
        sizeToFit()
        
        spinner.startAnimating()
        
        addSubview(spinner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        spinner.center = center
    }
}
