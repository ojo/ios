//
//  NowPlayingInfoService.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/30/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Alamofire
import UIKit
import Argo
import Firebase
import SwiftyJSON

class NowPlayingInfoService: NSObject, FIRMessagingDelegate {

    typealias Callback = (NowPlayingInfo) -> Void
    
    // maps from station.tag to callback function
    private var callbacks: [String:Callback] = [String:Callback]()

    private let API_URL = "https://api.ojo.world/api/v0/stations/now-playing"

    func request(infoFor station: Station,
                 callback: @escaping Callback) {
        let p = ["tag": station.tag]
        Alamofire.request(API_URL, parameters: p).responseJSON { response in
            if let json: Any = response.result.value {
                if let info = NowPlayingInfoService.AnyJsonApiToInfo(json) {
                    callback(info)
                }
            }
        }
    }

    func subscribe(to station: Station,
                   callback: @escaping Callback) {
        FIRMessaging.messaging().subscribe(toTopic: "/topics/now-playing-\(station.tag)")
        callbacks[station.tag] = callback
    }

    func unsubscribe(from station: Station) {
        FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/now-playing-\(station.tag)")
        callbacks[station.tag] = nil
    }
    
    func configure() {
        
        // SET UP FIREBASE. IT'S A TEDIOUS PROCESS
        
        // 1
        FIRApp.configure()
        
        // 2. For iOS 10 data message (sent via FCM)
        FIRMessaging.messaging().remoteMessageDelegate = INFO_SERVICE
        
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didRefresh),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
    
    }
    
    @objc private func didRefresh(_ notification: Notification) {
        connectToFCM()
    }
    
    func applicationDidBecomeActive() {
        connectToFCM()
    }
    
    func applicationWillTerminate() {
        // TODO: reconsider whether we should disconnect when we get backgrounded
        // we still want to update art as long as we're playing
        FIRMessaging.messaging().disconnect()
    }
    
    private func connectToFCM() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    
    // iOS <= 9 data messages
    func didReceiveRemoteNotification(userInfo: [AnyHashable : Any]) {
        print("didReceiveRemoteNotification")
        print(userInfo)
        let decoded: Decoded<NowPlayingInfo> = JSON(userInfo) <| "data"
        guard let info = decoded.value else { return }
        guard let cb = callbacks[info.stationTag] else { return }
        cb(info)
        print("calledback")
    }
    
    /// The callback to handle data message received via FCM for devices running iOS 10 or above.
    public func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        guard let value: Any = remoteMessage.appData["data"] else { return }
        guard let str = value as? String else { return }
        guard let data = str.data(using: .utf8) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data) else { return }
        let decoded: Decoded<NowPlayingInfo> = JSON(json) <| "attributes"
        guard let info = decoded.value else { return }
        guard let cb = callbacks[info.stationTag] else { return }
        cb(info)
    }

    private static func AnyJsonApiToInfo(_ data: Any) -> NowPlayingInfo? {
        // data is JSONAPI formatted, so extract first. then, decode.
        let decoded: Decoded<NowPlayingInfo> = JSON(data) <| ["data", "attributes"]
        if let info = decoded.value {
            return info
        }
        // TODO(btc): debug print only (get a real logger!)
        print(decoded.error.debugDescription)
        return nil
    }
}
