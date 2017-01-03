//
//  Analytics.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/1/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit
import Mixpanel

final class Analytics {
    
    private var client: MixpanelInstance
    
    private var currentStation: Station?
    
    init(client: MixpanelInstance) {
        self.client = client
    }
    
    func trackListeningSessionBegin(station s: Station) {
        currentStation = s
        time(event: "Listening Session")
    }
    
    func trackListeningSessionEnd() {
        if let s = currentStation {
            let p = ["Station": s.tag]
            track(event: "Listening Session", properties: p)
            currentStation = nil
        }
        
    }
    
    private func time(event: String) {
        client.time(event: event)
    }
    
    private func track(event: String, properties: Properties = [:]) {
        client.track(event: event, properties: properties)
    }
}
