//
//  Stations3ViewController.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/28/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit
import Reachability

class Stations3ViewController: UIViewController, StationViewDelegate {

    let reachability = Reachability()!
    
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
    
    private let offlineView: UIView = {
        let v = OfflineOverlayView()
        return v
    }()

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
        try? reachability.startNotifier()
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                self.hideOfflineView()
            }
        }
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self.showOfflineView()
            }
        }
        
        view.backgroundColor = UIColor.ojo_defaultVCBackground

        view.addSubview(bar)

        views = stations.map() { s in
            let v = StationView(frame: view.frame, station: s, delegate: self)
            return v
        }
        for v in views {
            view.addSubview(v)
        }

        view.addSubview(offlineView) // LAST ALWAYS
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
        
        let stationViewHeight = (parent.height - offsetFromBottom - bar.frame.maxY) / CGFloat(views.count)

        for (i, v) in views.enumerated() {
            v.frame = CGRect(x: 0,
                             y: offsetFromTop + bar.frame.height + CGFloat(i * Int(stationViewHeight)), // cast to Int to make sure i == 0 is handled correctly
                             width: parent.width,
                             height: stationViewHeight)
        }
        
        offlineView.frame = CGRect(x: 0,
                                   y: bar.frame.maxY,
                                   width: parent.width,
                                   height: parent.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if reachability.currentReachabilityStatus == .notReachable {
            showOfflineView()
        } else {
            hideOfflineView()
        }
    }

    private func showOfflineView() {
        offlineView.isHidden = false
    }
    
    private func hideOfflineView() {
        let fade: () -> Void = { [weak self] in self?.offlineView.alpha = 0 }
        let hide: (Bool) -> Void = { [weak self] _ in
            self?.offlineView.isHidden = true
            self?.offlineView.alpha = 1
        }
        UIView.animate(withDuration: 1, animations: fade, completion: hide)
    }
}
