//
//  RootNavigationController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit
import LNPopupController;

class RootNavigationController : UINavigationController {
    
    // results in a circular reference, but I think it's okay since this class
    // and the Miniplayer are always active/in scope.
    var miniplayer: Miniplayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ojo_defaultVCBackground
        
        navigationBar.clipsToBounds = true // removes the bottom border of nav bar
        navigationBar.isTranslucent = false
    }
        
    override func viewDidAppear(_ animated: Bool) {
        miniplayer = Miniplayer(self, playbackManager: PLAYBACK_MANAGER)
    }
}
