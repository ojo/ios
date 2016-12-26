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
        return result
    }()

    var artistName: UILabel = {
        var result = UILabel()
        result.text = "placeholder artist name"
        return result
    }()
    
    var songName: UILabel = {
        var result = UILabel()
        result.text = "placeholder song name"
        return result
    }()

    let musicPlayBackButton = MusicPlaybackButton()
    
    // this is a convenient way to create this view controller without a imageURL
    var currentStation: Station?
    
    // this is a convenient way to create this view controller without a imageURL
    init(initialStation: Station) {
        self.currentStation = initialStation
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
}
