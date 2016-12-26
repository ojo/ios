//
//  MusicPlayerViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class MusicPlayerViewController : UIViewController {
    var albumArt: UIImageView = {
        var result = UIImageView(image: UIImage(named: "album_art_placeholder"))
        result.backgroundColor = UIColor.red
        return result
    }()

    var artistName: UILabel = {
        var result = UILabel()
        result.text = "placeholder artist name"
        result.textAlignment = NSTextAlignment.center
        return result
    }()
    
    var songName: UILabel = {
        var result = UILabel()
        result.text = "placeholder song name"
        result.textAlignment = NSTextAlignment.center
        return result
    }()

    let musicPlayBackButton = MusicPlaybackButton()
    
    var playbackManager: PlaybackManager?
    init(playbackManager: PlaybackManager) {
        self.playbackManager = playbackManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(albumArt)
        self.view.addSubview(artistName)
        self.view.addSubview(songName)
        self.view.addSubview(musicPlayBackButton)
    }
    
    
    override func viewDidLayoutSubviews() {
        let width = self.view.bounds.width
        let paddingX: Int = 6
        let albumArtPaddingY: Int = 66
        let widthHeight = Int(width) - paddingX
        albumArt.frame = CGRect(x: paddingX, y: albumArtPaddingY, width: widthHeight, height: widthHeight)
        
        let spacing: Int = 26
        let songNameY = Int(albumArt.frame.maxY) + spacing
        songName.frame = CGRect(x: paddingX, y: songNameY, width: widthHeight, height: spacing)

        let artistNameY = Int(songName.frame.maxY) + spacing
        artistName.frame = CGRect(x: paddingX, y: artistNameY, width: widthHeight, height: spacing)
    }
}
