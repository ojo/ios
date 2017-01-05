//
//  InfoPresenter.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/5/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

class TwoLinePresenter {
    let info: NowPlayingInfo
    
    var title: String {
        get {
            return info.title == "" ? info.artist : info.title
        }
    }
    
    var subtitle: String {
        get {
            var artistAndMaybeAlbum = info.artist
            if info.album != "" {
                artistAndMaybeAlbum += " - \(info.album)"
            }
            return info.title == "" ? info.album : artistAndMaybeAlbum
        }
    }
    
    init(forInfo info: NowPlayingInfo) {
        self.info = info
    }
}
