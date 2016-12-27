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
        self.view.backgroundColor = DEFAULT_VC_BACKGROUND_COLOR
    }
        
    override func viewDidAppear(_ animated: Bool) {
        let vc = NowPlayingViewController(playbackManager: playbackManager)
        self.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
    }
}
