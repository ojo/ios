//
//  MusicPlayerViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import AlamofireImage
import Foundation
import UIKit

class NowPlayingViewController : UIViewController, PlaybackDelegate {
    
    var imageView: UIImageView = {
        var result = OJORoundedImageView()
        result.contentMode = .scaleAspectFill
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

    let playbackToggle: MusicPlaybackButton = {
        let result = MusicPlaybackButton()
        return result
    }()
    
    var playbackManager: PlaybackManager?
    
    init(playbackManager: PlaybackManager) {
        self.playbackManager = playbackManager
        super.init(nibName: nil, bundle: nil)
        playbackManager.addDelegate(self)
        
        playbackToggle.addTarget(self,
                                 action: #selector(playButtonPressed),
                                 for: .touchUpInside)
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
        view.addSubview(playbackToggle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let info = playbackManager?.nowPlayingInfo,
            let station = playbackManager?.station {
            incoming(info: info, forStation: station)
        }
    }
    
    override func viewDidLayoutSubviews() {
        let width = self.view.bounds.width
        let paddingX: CGFloat = 6
        let albumArtPaddingY: CGFloat = 66
        let widthHeight = width - 2 * paddingX
        imageView.frame = CGRect(x: paddingX,
                                y: albumArtPaddingY,
                                width: widthHeight,
                                height: widthHeight)
        
        let spacingBetweenImageAndTitle: CGFloat = 25
        let songNameY = imageView.frame.maxY + spacingBetweenImageAndTitle
        let lineHeight: CGFloat = 25
        titleView.frame = CGRect(x: paddingX,
                                y: songNameY,
                                width: widthHeight,
                                height: lineHeight)

        let artistNameY = titleView.frame.maxY + DEFAULT_MARGIN_PX
        artistView.frame = CGRect(x: paddingX,
                                  y: artistNameY,
                                  width: widthHeight,
                                  height: lineHeight)
        let toggleWH: CGFloat = 100
        playbackToggle.frame = CGRect(x: width/2 - toggleWH/2,
                                      y: artistView.frame.maxY + DEFAULT_MARGIN_PX,
                                      width: toggleWH,
                                      height: toggleWH)
    }
    
    func didChange(state: PlaybackState) {
        playbackToggle.playbackState = state
    }
    
    func incoming(info: NowPlayingInfo, forStation station: Station) {
        
        // BUG: If user taps station and immediately taps the Miniplayer to open
        // this screen, the screen appears without any content. What in the world
        // is happening?

        if info.title == "" {
            // then the server hasn't been fixed yet.
            titleView.text = info.artist
            artistView.text = info.album
        } else {
            titleView.text = info.title
            artistView.text = "\(info.artist) - \(info.album)"
        }
        if info.artwork.isPresent(), let c = info.artwork.dominantUIColor() {
            let s = imageView.frame.size
            let placeholder = UIImage.from(color: c, withSize: s)
            guard let str = info.artwork.url500, let url = URL(string: str) else {
                imageView.image = playbackManager?.station?.image
                return
            }
            imageView.af_setImage(withURL: url, placeholderImage: placeholder)
        } else {
            imageView.image = playbackManager?.station?.image
        }
    }
    
    func playButtonPressed(_ e: UIEvent) {
        switch playbackToggle.playbackState {
        case .buffering:
            break
        case .started:
            playbackManager?.stop()
        case .stopped:
            playbackManager?.play()
        }
    }
}
