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

    private let API_URL = API_HOST + "/api/v0/stations/now-playing"

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
        unsubscribe(tag: station.tag)
    }

    func unsubscribe(tag: String) {
        FIRMessaging.messaging().unsubscribe(fromTopic: "/topics/now-playing-\(tag)")
        callbacks[tag] = nil
    }

    func configure() {

        // SET UP FIREBASE. IT'S A TEDIOUS PROCESS

        // 1
        FIRApp.configure()

        // 2. For iOS 10 data message (sent via FCM)
        FIRMessaging.messaging().remoteMessageDelegate = self

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
                Log.error?.message("Unable to connect to Firebase Cloud Messaging: \(error)")
            } else {
                Log.info?.message("Connected to Firebase Cloud Messaging")
            }
        }
    }


    // iOS <= 9 data messages
    func didReceiveRemoteNotification(userInfo: [AnyHashable : Any]) {
        guard let value: Any = userInfo["data"] else {
            Log.error?.message("NPInfo object is missing 'data' key")
            return
        }
        guard let str = value as? String else {
            Log.error?.message("Value for 'data' in NPInfo object is not a string")
            return
        }
        guard let data = str.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data) else {
            Log.error?.message("Failed to decode JSON object from NPInfo string")
            return
        }
        let decoded: Decoded<NowPlayingInfo> = JSON(json) <| "attributes"
        guard let info = decoded.value else {
            Log.error?.message(decoded.error.debugDescription)
            return
        }
        guard let cb = callbacks[info.stationTag] else {
            Log.error?.message("No NPInfo callback registered for station tag: '\(info.stationTag)'")
            unsubscribe(tag: info.stationTag)
            return
        }
        cb(info)
    }

    /// The callback to handle data message received via FCM for devices running iOS 10 or above.
    public func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        didReceiveRemoteNotification(userInfo: remoteMessage.appData)
    }

    private static func AnyJsonApiToInfo(_ data: Any) -> NowPlayingInfo? {
        // data is JSONAPI formatted, so extract first. then, decode.
        let decoded: Decoded<NowPlayingInfo> = JSON(data) <| ["data", "attributes"]
        if let info = decoded.value {
            return info
        }
        Log.error?.message(decoded.error.debugDescription)
        return nil
    }
}
