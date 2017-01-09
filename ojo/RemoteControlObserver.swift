//
//  RemoteControlDelegate.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/30/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit

protocol RemoteControlObserver: class {
    func received(eventType: UIEventSubtype)
}
