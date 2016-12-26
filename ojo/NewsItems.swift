//
//  NewsItems.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation

let NewsItems: [NewsItem] = [
    NewsItem(
        id: 849,
        category: "News",
        title: "UNC walks out again",
        subtitle: "",
        straphead: "Swearing-in ceremony",
        body: "Attorney and United National Congress (UNC) Senator, Gerald Ramdeen, lead a walkout of UNC councillors at the Sangre Grande Regional Corporation this afternoon.\r\n<br>\r\nThe swearing-in ceremony of aldermen of the Corporation took place today, although the deadlock has not been resolved. Both the People's National Movement (PNM) and UNC secured four electoral districts.\r\n<br>\r\nIncumbent Terry Rondon, who faced objections from two councillors, was re-elected as chairman of the Corporation after the walkout.",
        photoThumbUrl: "http://s3.amazonaws.com/ttrn-api-photos/news_items/photos/000/000/849/thumb/Screen_Shot_2016-12-15_at_4.45.53_PM.png?1481835001",
        photoDominantColor: "#201f17",
        photoUrl: "http://s3.amazonaws.com/ttrn-api-photos/news_items/photos/000/000/849/original/Screen_Shot_2016-12-15_at_4.45.53_PM.png?1481835001",
        photoCaption: ""
    ),
    NewsItem(
        id: 848,
        category: "News",
        title: "Murder in Maraval",
        subtitle: "",
        straphead: "Swearing-in ceremony",
        body: "A 24-year-old man is dead following a shooting incident this morning in Maraval.\r\n<br>Around 3:00 am, Michael Sylvester was asleep in his Nissan Almera motor vehicle when he was approached by a group of men.\r\nSeveral explosions were heard and Sylvester was found bleeding from multiple gunshot injuries.\r\n<br>He was rushed to the Port of Spain General Hospital where he was pronounced dead on arrival.\r\n<br>Investigations are continuing.",
        photoThumbUrl: "http://s3.amazonaws.com/ttrn-api-photos/news_items/photos/000/000/848/thumb/Screen_Shot_2016-09-09_at_9.29.11_AM.png?1481826951",
        photoDominantColor: "#070502",
        photoUrl: "http://s3.amazonaws.com/ttrn-api-photos/news_items/photos/000/000/848/original/Screen_Shot_2016-09-09_at_9.29.11_AM.png?1481826951",
        photoCaption: ""
    ),
]

struct NewsItem {
    var id: Int
    var category: String
    var title: String
    var subtitle: String
    var straphead: String
    var body: String
    var photoThumbUrl: String // NSURL?
    var photoDominantColor: String // hex?
    var photoUrl: String // NSURL?
    var photoCaption: String
}
