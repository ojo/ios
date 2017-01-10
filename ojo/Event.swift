//
//  Event.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/9/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import Foundation

struct Event {
    let id: Int
    let name: String
    let host: String
    
    let description: String?
    let category: String?
    let location: Location?
    
    let photoURL: String
    let photoDominantColor: String
    
    struct Location {
        let name: String
        
        let street: String
        let city: String
        let state: String
        let zip: String
        let country: String
        
        let latitude: Float
        let longitude: Float
    }
}
