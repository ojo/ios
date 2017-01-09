//
//  RemoteControlResponder.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/30/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit
import MediaPlayer

class RemoteControlResponder: UIResponder {
    
    private var observers = [RemoteControlObserver]()
    
    override init() {
        super.init()
        
        let cc = MPRemoteCommandCenter.shared()
        cc.playCommand.addTarget { _ in
            self.observers.forEach { $0.received(eventType: .remoteControlPlay) }
            return .success
        }
        cc.pauseCommand.addTarget { _ in
            self.observers.forEach { $0.received(eventType: .remoteControlPause) }
            return .success
        }
    }

    public func add(delegate: RemoteControlObserver) {
        observers.append(delegate)
    }
    
    public func remove(delegate: RemoteControlObserver) {
        observers = observers.filter() { $0 !== delegate }
    }
}
