//
//  Stations3ViewController.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/28/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit

class Stations3ViewController: UIViewController, StationViewDelegate {

    private var bar: UINavigationBar = {
        let v = UINavigationBar()
        v.items = [ UINavigationItem()]
        v.topItem?.titleView = DefaultTopItemLabel("OJO Streams")
        v.backgroundColor = UIColor.ojo_defaultVCBackground
        v.clipsToBounds = true // removes bottom border
        v.isTranslucent = false
        return v
    }()

    private let stations: [Station]

    private var views: [StationView] = [StationView]()

    init(stations: [Station]) {
        self.stations = stations
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    func stationSelected(_ s: Station) {
        PLAYBACK_MANAGER.station = s
        PLAYBACK_MANAGER.play()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ojo_defaultVCBackground
        
        view.addSubview(bar)

        views = stations.map() { s in
            let v = StationView(frame: view.frame, station: s, delegate: self)
            return v
        }
        for v in views {
            view.addSubview(v)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let offsetFromTop = topLayoutGuide.length
        let offsetFromBottom = bottomLayoutGuide.length
        let parent = view.bounds
        
        bar.frame = CGRect(x: 0,
                           y: offsetFromTop,
                           width: parent.width,
                           height: 44)
        
        let viewH = (parent.height - offsetFromBottom - bar.frame.maxY) / CGFloat(views.count)

        for (i, v) in views.enumerated() {
            v.frame = CGRect(x: 0,
                             y: offsetFromTop + bar.frame.height + CGFloat(i * Int(viewH)), // cast to Int to make sure i == 0 is handled correctly
                             width: parent.width,
                             height: viewH)
        }
    }
}
