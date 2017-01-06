//
//  Analytics.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/1/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

final class Analytics {
    
    typealias Properties = [String:AnyObject]
    
    private var client: AnalyticsType?
    
    private var currentStation: Station?
    
    init(client: AnalyticsType) {
        self.client = client
    }
    
    func trackListeningSessionBegin(station s: Station) {
        currentStation = s
        time(event: "Listening Session")
    }
    
    func trackListeningSessionEnd() {
        if let s = currentStation {
            let p: Properties = ["Station": s.tag as AnyObject]
            track(event: "Listening Session", properties: p)
            currentStation = nil
        }
        
    }
    
    private func time(event: String) {
        client?.time(event: event)
    }
    
    private func track(event: String, properties: Properties = [:]) {
        client?.track(event: event, properties: properties)
    }
}
