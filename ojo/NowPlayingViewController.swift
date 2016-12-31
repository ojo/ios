//
//  MusicPlayerViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class NowPlayingViewController : UIViewController, PlaybackDelegate {
    
    var albumArt: UIImageView = {
        var result = OJORoundedImageView()
        return result
    }()

    var artistName: UILabel = {
        var result = UILabel()
        result.text = DEFAULT_PLACEHOLDER_TEXT
        result.textAlignment = NSTextAlignment.center
        return result
    }()
    
    var songName: UILabel = {
        var result = UILabel()
        result.text = DEFAULT_PLACEHOLDER_TEXT
        result.textAlignment = NSTextAlignment.center
        return result
    }()

    let musicPlayBackButton = MusicPlaybackButton()
    
    var playbackManager: PlaybackManager?
    
    init(playbackManager: PlaybackManager) {
        self.playbackManager = playbackManager
        super.init(nibName: nil, bundle: nil)
        playbackManager.addDelegate(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.ojo_defaultVCBackground
        
        view.addSubview(albumArt)
        view.addSubview(artistName)
        view.addSubview(songName)
        
    }
    
    override func viewDidLayoutSubviews() {
        let width = self.view.bounds.width
        let paddingX: Int = 6
        let albumArtPaddingY: Int = 66
        let widthHeight = Int(width) - 2 * paddingX
        albumArt.frame = CGRect(x: paddingX,
                                y: albumArtPaddingY,
                                width: widthHeight,
                                height: widthHeight)
        
        let spacing: Int = 26
        let songNameY = Int(albumArt.frame.maxY) + spacing
        songName.frame = CGRect(x: paddingX,
                                y: songNameY,
                                width: widthHeight,
                                height: spacing)

        let artistNameY = Int(songName.frame.maxY) + spacing
        artistName.frame = CGRect(x: paddingX,
                                  y: artistNameY,
                                  width: widthHeight,
                                  height: spacing)
    }
    
    func didChange(state: PlaybackState) {
        switch state {
        case .buffering: break
        case .started: break
        case .stopped: break
        }
    }
    
    func incoming(info: NowPlayingInfo, future: Future<UIImage>) {
        
        // BUG: If user taps station and immediately taps the Miniplayer to open
        // this screen, the screen appears without any content. What in the world
        // is happening?

        if info.title == "" {
            // then the server hasn't been fixed yet.
            songName.text = info.artist
            artistName.text = info.album
        } else {
            songName.text = info.title
            artistName.text = info.artist
        }
        albumArt.image = playbackManager?.station?.image
        future.onSuccess() { albumArt.image = $0 }
    }
    
    func playButtonPressed(_ e: UIEvent) {
        // TODO toggle
    }
}
