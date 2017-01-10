//
//  EventMocks.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/9/17.
//  Copyright © 2017 TTRN. All rights reserved.
//


fileprivate let machelMondayLocation = Event.Location(name: "Hasely Crawford Stadium",
                                                      street: nil,
                                                      city: "Port-of-Spain", 
                                                      state: nil, 
                                                      zip: nil, 
                                                      country: "Trinidad", 
                                                      latitude: nil, 
                                                      longitude: nil)

let MOCK_EVENTS = [
    Event(id: 1,
               name: "Machel Monday",
               host: "Machel Montano",
               description: "", 
               category: "music",
               location: machelMondayLocation,
               photoURL: "http://machelmontano.com/site/wp-content/uploads/2015/02/J7C_8635-1024x682.jpg",
               photoDominantColor: "#495810")
]
