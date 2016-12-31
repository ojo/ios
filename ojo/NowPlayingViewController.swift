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
    
    var imageView: UIImageView = {
        var result = OJORoundedImageView()
        return result
    }()
    
    var titleView: UILabel = {
        var result = UILabel()
        result.text = DEFAULT_PLACEHOLDER_TEXT
        result.font = UIFont(name: DEFAULT_FONT_BOLD, size: 22)
        result.textColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0) // #595959 TODO extract when you use it enough throughout the app to share it and give it a name
        result.textAlignment = NSTextAlignment.center
        return result
    }()

    var artistView: UILabel = {
        var result = UILabel()
        result.text = DEFAULT_PLACEHOLDER_TEXT
        result.font = UIFont(name: DEFAULT_FONT, size: 22)
        result.textColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0) // #595959 TODO extract when you use it enough throughout the app to share it and give it a name
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
        
        view.addSubview(imageView)
        view.addSubview(artistView)
        view.addSubview(titleView)
    }
    
    override func viewDidLayoutSubviews() {
        let width = self.view.bounds.width
        let paddingX: Int = 6
        let albumArtPaddingY: Int = 66
        let widthHeight = Int(width) - 2 * paddingX
        imageView.frame = CGRect(x: paddingX,
                                y: albumArtPaddingY,
                                width: widthHeight,
                                height: widthHeight)
        
        let spacing: Int = 25
        let songNameY = Int(imageView.frame.maxY) + spacing
        titleView.frame = CGRect(x: paddingX,
                                y: songNameY,
                                width: widthHeight,
                                height: spacing)

        let artistNameY = Int(titleView.frame.maxY)
        artistView.frame = CGRect(x: paddingX,
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
            titleView.text = info.artist
            artistView.text = info.album
        } else {
            titleView.text = info.title
            artistView.text = info.artist
        }
        imageView.image = playbackManager?.station?.image
        future.onSuccess() { imageView.image = $0 }
    }
    
    func playButtonPressed(_ e: UIEvent) {
        // TODO toggle
    }
}
