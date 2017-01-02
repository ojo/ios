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
        let STATUS_H = UIApplication.shared.statusBarFrame.height
        let MINIPLAYER_H: CGFloat = {
            // this is a hack. TODO(btc): replace with a dynamic lookup of the miniplayer's height
            if #available(iOS 10.0, *) {
                return 64
            }
            return 40
        }()
        let TAB_BAR_H: CGFloat = UITabBarController().tabBar.frame.height
        
        let f = view.frame
        let viewH = (f.height - MINIPLAYER_H - DEFAULT_MARGIN_PX - TAB_BAR_H - STATUS_H) / CGFloat(views.count)
        
        for (i, v) in views.enumerated() {
            v.frame = CGRect(x: 0,
                             y: STATUS_H + CGFloat(i * Int(viewH)), // cast to Int to make sure i == 0 is handled correctly
                             width: f.width,
                             height: viewH)
        }
    }    
}
