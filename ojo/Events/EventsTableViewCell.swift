//
//  EventsTableViewCell.swift
//  ojo
//
//  Created by Chinna Addepally on 1/12/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    var eventName: String!
    var eventURL: String!
    var eventTime: String!
    
    var eventLabel: UILabel!
    var eventTimeLabel: UILabel!
    var eventImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func getLabel(forText:String?,alignment:NSTextAlignment,color:UIColor) -> UILabel {
        let label:UILabel = UILabel.init(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = forText
        label.textAlignment = alignment
        label.textColor = color
        return label
    }

    func createViews() {
        
        if eventLabel == nil {
            eventLabel = getLabel(forText: "", alignment: .left, color: UIColor.black)
            eventLabel.numberOfLines = 0
            eventLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)!
            
        }
        self.contentView.addSubview(eventLabel)

        if eventTimeLabel == nil {
            eventTimeLabel = getLabel(forText: "", alignment: .left, color: UIColor.black)
            eventTimeLabel.numberOfLines = 0
            eventTimeLabel.font = UIFont(name: "HelveticaNeue", size: 15.0)!
        }
        self.contentView.addSubview(eventTimeLabel)
        
        if eventImage == nil {
            eventImage = UIImageView.init(frame: CGRect.zero)
            eventImage.translatesAutoresizingMaskIntoConstraints = false
//            eventImage.contentMode = UIViewContentMode.scaleAspectFit
        }
        eventImage.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(eventImage)
    }
    
    func createConstraints() {
        let viewsDict:NSDictionary = ["Image":eventImage,"EventName":eventLabel,"EventTime":eventTimeLabel]

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[EventName]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDict as! [String:AnyObject]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[EventTime]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDict as! [String:AnyObject]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[Image]-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDict as! [String:AnyObject]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[EventName(16)]-2-[EventTime(16)]-[Image(200)]-5-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDict as! [String:AnyObject]))

    }
}
