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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DEFAULT_VC_BACKGROUND_COLOR
        
        navigationBar.clipsToBounds = true // removes the bottom border
        navigationBar.isTranslucent = false
    }
        
    override func viewDidAppear(_ animated: Bool) {
        let vc = NowPlayingViewController(playbackManager: PLAYBACK_MANAGER)
        self.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
    }
}
