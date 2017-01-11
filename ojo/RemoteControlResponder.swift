//
//  RemoteControlResponder.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/30/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import MediaPlayer

class RemoteControlResponder {
    
    init(_ playbackManager: PlaybackManager) {        
        let cc = MPRemoteCommandCenter.shared()
        cc.playCommand.addTarget { [weak playbackManager] _ in
            playbackManager?.play()
            return .success
        }
        cc.pauseCommand.addTarget { [weak playbackManager] _ in
            playbackManager?.stop()
            return .success
        }
        // TODO handle skip forward and skip backward
    }
}
