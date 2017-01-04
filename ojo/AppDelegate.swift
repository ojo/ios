//
//  AppDelegate.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/25/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit
import Mixpanel

// TODO: consider DI
let INFO_SERVICE = NowPlayingInfoService()
let PLAYBACK_MANAGER = PlaybackManager(infoService: INFO_SERVICE)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let rootVC = UITabBarRootViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()

        INFO_SERVICE.configure()
        application.registerForRemoteNotifications()
        
        /*
        let mp = Mixpanel.initialize(token: "94b5a087efd368348e9765150a465858")
        let analytics = Analytics(client: mp)
        PlaybackTracker.bind(analytics: analytics,
                             playbackManager: PLAYBACK_MANAGER)
        */

        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        INFO_SERVICE.didReceiveRemoteNotification(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        INFO_SERVICE.didReceiveRemoteNotification(userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // only req'd if swizzling disabled
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        INFO_SERVICE.applicationDidEnterBackground()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        INFO_SERVICE.applicationDidBecomeActive()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

