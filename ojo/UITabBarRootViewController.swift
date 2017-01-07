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
                                                         bounds: view.frame) // FIXME: bounds or frame?
        let radioImage = UIImage(named: "radio")
        radioVC.tabBarItem = UITabBarItem(title: "Radio",
                                          image: radioImage,
                                          selectedImage: radioImage)
        let newsVC = NewsNavigationController(rootViewController: NewsFeedViewController(frame: view.frame))
        let newsImage = UIImage(named: "news")
        newsVC.tabBarItem = UITabBarItem(title: "News",
                                          image: newsImage,
                                          selectedImage: newsImage)
        newsVC.tabBarItem.badgeValue = "4"
        let eventsVC = DiscoverEventsViewController()
        let eventsImage = UIImage(named: "events")
        eventsVC.tabBarItem = UITabBarItem(title: "Discover Events",
                                         image: eventsImage,
                                         selectedImage: eventsImage)
        switch RELEASE_PHASE {
        case 1:
            viewControllers = [radioVC]
        case 2:
            viewControllers = [newsVC, radioVC]
        case 3:
            viewControllers = [newsVC, radioVC, eventsVC]
        default:
            viewControllers = [radioVC]
        }
        selectedViewController = radioVC // always
    }
}
