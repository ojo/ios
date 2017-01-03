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
        
        // configure the appearance of this container
        
        view.backgroundColor = UIColor.ojo_defaultVCBackground
        tabBar.tintColor = UIColor.ojo_red

        // add the miniplayer
        miniplayer = Miniplayer(self, playbackManager: PLAYBACK_MANAGER)
        
        hookUpTheDifferentSectionsOfTheApp()
    }
    
    func hookUpTheDifferentSectionsOfTheApp() {
        let radioVC = StationsViewControllerFactory.make(withStations: STATIONS,
                                                         bounds: view.frame)
        let radioImage = UIImage(named: "radio")
        radioVC.tabBarItem = UITabBarItem(title: "Radio",
                                          image: radioImage,
                                          selectedImage: radioImage)
        let newsVC = NewsFeedViewController()
        let newsImage = UIImage(named: "news")
        newsVC.tabBarItem = UITabBarItem(title: "News",
                                          image: newsImage,
                                          selectedImage: newsImage)
        let eventsVC = DiscoverEventsViewController()
        let eventsImage = UIImage(named: "events")
        eventsVC.tabBarItem = UITabBarItem(title: "Discover Events",
                                         image: eventsImage,
                                         selectedImage: eventsImage)
        viewControllers = [newsVC, radioVC, eventsVC]
        selectedViewController = radioVC
    }
}
