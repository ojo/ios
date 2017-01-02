//
//  UITabBarRootViewController.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/1/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

class UITabBarRootViewController: UITabBarController {
    
    var miniplayer: Miniplayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ojo_defaultVCBackground
        miniplayer = Miniplayer(self, playbackManager: PLAYBACK_MANAGER)
        
        let radioVC = StationsViewControllerFactory.make(withStations: STATIONS,
                                                         bounds: view.frame)
        radioVC.tabBarItem = UITabBarItem(title: "Radio",
                                          image: UIImage(named: "radio"),
                                          selectedImage: UIImage(named: "radio"))
        
        viewControllers = [radioVC]
    }
}