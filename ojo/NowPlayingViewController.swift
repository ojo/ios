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
import MarqueeLabel

class NowPlayingViewController : UIViewController {
    
    var imageView: UIImageView = {
        var result = OJORoundedImageView()
        result.contentMode = .scaleAspectFill
        return result
    }()
    
    var titleView: UILabel = {
        let result = MarqueeLabel(frame: CGRect.zero, rate: 30, andFadeLength: 100)!
        result.trailingBuffer = 50
        result.text = DEFAULT_PLACEHOLDER_TEXT
        result.font = UIFont(name: DEFAULT_FONT_BOLD, size: 22)
        result.textColor = UIColor.ojo_grey_59
        result.textAlignment = NSTextAlignment.center
        return result
    }()

    var artistView: UILabel = {
        let result = MarqueeLabel(frame: CGRect.zero, rate: 30, andFadeLength: 100)!
        result.trailingBuffer = 50
        result.text = DEFAULT_PLACEHOLDER_TEXT
        result.font = UIFont(name: DEFAULT_FONT, size: 22)
        result.textColor = UIColor.ojo_grey_59
        result.textAlignment = NSTextAlignment.center
        return result
    }()

    let playbackToggle: PlaybackToggleButton = {
        let result = PlaybackToggleButton()
        return result
    }()
    
    var playbackManager: PlaybackManager?
    
    init(playbackManager: PlaybackManager) {
        self.playbackManager = playbackManager
        super.init(nibName: nil, bundle: nil)
        playbackManager.addObserver(self)
        
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

extension NowPlayingViewController: PlaybackObserver {
    
    func didChange(state: PlaybackState) {
        playbackToggle.playbackState = state
    }
    
    func incoming(info: NowPlayingInfo, forStation station: Station) {
        // BUG: If user taps station and immediately taps the Miniplayer to open
        // this screen, the screen appears without any content. What in the world
        // is happening?
        
        let p = TwoLinePresenter(forInfo: info)
        titleView.text = p.title
        artistView.text = p.subtitle
        
        if info.artwork.isPresent(), let c = info.artwork.dominantUIColor() {
            let placeholder = UIImage.from(color: c)
            guard let str = info.artwork.url500, let url = URL(string: str) else {
                imageView.image = playbackManager?.station?.image
                return
            }
            imageView.af_setImage(withURL: url, placeholderImage: placeholder)
        } else {
            imageView.image = playbackManager?.station?.image
        }
    }
}
