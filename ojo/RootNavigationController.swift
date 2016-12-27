//
//  OJORootNavigationController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit
import LNPopupController;

let stationManager = StationManager()
let playbackManager = PlaybackManager(stationManager: stationManager)

class OJORootNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
    }
        
    override func viewDidAppear(_ animated: Bool) {
        let vc = MusicPlayerViewController(playbackManager: playbackManager)
        self.presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
    }
}
