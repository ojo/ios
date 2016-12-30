//
//  MusicPlayerViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class NowPlayingViewController : UIViewController, PlaybackManagerDelegate {
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
        playbackManager.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = DEFAULT_VC_BACKGROUND_COLOR
        
        self.view.addSubview(albumArt)
        self.view.addSubview(artistName)
        self.view.addSubview(songName)
        self.view.addSubview(musicPlayBackButton)
        
        let play = UIBarButtonItem(image: MusicPlaybackButton.playImage, landscapeImagePhone: nil, style: .plain, target: self, action: #selector(playButtonPressed))
        self.popupItem.rightBarButtonItems = [play]
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
    
    func playbackDidChangeState(_ s: PlaybackState) {
        switch s {
        case .buffering:
            playbackToggle.buffering()
        case .started:
            playbackToggle.playing()
        case .stopped:
            playbackToggle.stopped()
        }
    }
    
    func playButtonPressed(_ e: UIEvent) {
        playbackManager?.play()
    }
}
