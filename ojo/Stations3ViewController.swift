//
//  Stations3ViewController.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/28/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit
import LNPopupController

class Stations3ViewController: UIViewController, StationViewDelegate {

    private let label: UIView = DefaultTopItemLabel("OJO Streams")

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

        views = stations.map() { s in
            let v = StationView(frame: view.frame, station: s, delegate: self)
            return v
        }
        for v in views {
            view.addSubview(v)
        }
    }

    override func viewDidLayoutSubviews() {
        let offsetFromTop = topLayoutGuide.length
        let offsetFromBottom = bottomLayoutGuide.length

        let f = view.frame
        let viewH = (f.height - DEFAULT_MARGIN_PX - offsetFromBottom - offsetFromTop) / CGFloat(views.count)

        for (i, v) in views.enumerated() {
            v.frame = CGRect(x: 0,
                             y: offsetFromTop + CGFloat(i * Int(viewH)), // cast to Int to make sure i == 0 is handled correctly
                             width: f.width,
                             height: viewH)
        }
    }
}
