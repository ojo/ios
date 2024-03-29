//
//  AnalyticsType.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/5/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

protocol AnalyticsType {
    func track(event: String?, properties: [String:AnyObject]?)
    func time(event: String)
}
