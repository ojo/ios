//
//  UpcomingEventsViewController.swift
//  ojo
//
//  Created by Chinna Addepally on 1/12/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

class UpcomingEventsViewController: UIViewController {
    
    var eventsTableView: UITableView!
    var upcomingEvents:NSMutableArray = NSMutableArray()
    
    func createViewsAndConstraints() {
        eventsTableView = UITableView.init(frame: CGRect.zero, style: .plain)
        eventsTableView!.translatesAutoresizingMaskIntoConstraints = false
        eventsTableView!.dataSource = self
        eventsTableView!.delegate = self
        eventsTableView!.layer.borderWidth = 1
        eventsTableView!.separatorStyle = .none
        eventsTableView?.allowsSelection = false
        eventsTableView!.register(EventsTableViewCell.self, forCellReuseIdentifier: "Event")
        self.view.addSubview(eventsTableView!)
        
        let viewsDict:NSDictionary = ["EventsTable":eventsTableView]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[EventsTable]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDict as! [String:AnyObject]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[EventsTable]|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDict as! [String:AnyObject]))

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        createViewsAndConstraints()
        
        let eventDictionary1: NSDictionary = ["eventName": "International Music Festival","eventTime":"Jan 21,2017-Jan 29,2017","url":"https://photoimage.blob.core.windows.net/postimage/bcf1dfd7-0cbf-4830-bc74-ccee1806866c_20170108152425478"]
        
        let eventDictionary2: NSDictionary = ["eventName": "International Music Festival","eventTime":"Jan 25,2017-Jan 31,2017","url":"https://photoimage.blob.core.windows.net/postimage/bcf1dfd7-0cbf-4830-bc74-ccee1806866c_20170107152150832"]

        let eventDictionary3: NSDictionary = ["eventName": "International Music Festival","eventTime":"Feb 1,2017-Feb 10,2017","url":"https://photoimage.blob.core.windows.net/postimage/bcf1dfd7-0cbf-4830-bc74-ccee1806866c_20170107035146575"]
        
        upcomingEvents.add(eventDictionary1)
        upcomingEvents.add(eventDictionary2)
        upcomingEvents.add(eventDictionary3)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UpcomingEventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UpcomingEventsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableIdentifier = "Event"
        var cell:EventsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as? EventsTableViewCell
        if cell == nil {
            cell = EventsTableViewCell.init(style: .default, reuseIdentifier: reusableIdentifier)
            cell?.selectionStyle =  UITableViewCellSelectionStyle.none
        }
        
        let eventDictionary: NSDictionary = upcomingEvents.object(at: indexPath.row) as! NSDictionary
        
        cell?.createViews()
        cell?.createConstraints()

        cell?.eventTimeLabel.text = eventDictionary.object(forKey: "eventTime") as! String?
        cell?.eventLabel.text = eventDictionary.object(forKey: "eventName") as? String
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageURL: String = eventDictionary.object(forKey: "url") as! String
            let image: UIImage? = UIImage.init(data: NSData(contentsOf: NSURL(string: imageURL)! as URL)! as Data)

            // Bounce back to the main thread to update the UI
            DispatchQueue.main.async {
                cell?.eventImage.image = image
            }
        }        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 245
    }

}




