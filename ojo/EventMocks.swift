//
//  EventMocks.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/9/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import Foundation

/*
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
               isFeatured: true,
               description: "", 
               category: "music",
               location: machelMondayLocation,
               photoURL: "http://machelmontano.com/site/wp-content/uploads/2015/02/J7C_8635-1024x682.jpg",
               photoDominantColor: "#495810")
]
*/


let MOCK_EVENTS: [EventItem] = [
    EventItem(
        id: 1,
        category: "Event Name",
        title: "UNC walks out again",
        body: "Attorney and United National Congress",
        subtitle: "",
        straphead: "Swearing-in ceremony",
        photo: EventItem.Photo(
            thumbURL: "http://s3.amazonaws.com/ttrn-api-photos/news_items/photos/000/000/849/thumb/Screen_Shot_2016-12-15_at_4.45.53_PM.png?1481835001",
            dominantColor: "#201f17",
            URL: "http://s3.amazonaws.com/ttrn-api-photos/news_items/photos/000/000/849/original/Screen_Shot_2016-12-15_at_4.45.53_PM.png?1481835001",
            caption: ""
        )
    )
]
