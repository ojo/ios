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
    
    private let MINIPLAYER_HEIGHT: CGFloat = {
        // this is a hack. TODO(btc): replace with a dynamic lookup of the miniplayer's height
        if #available(iOS 10.0, *) {
            return 64
        }
        return 40
    }()
    
    var stations: [Station] = [Station]()
    var views: [UIView] = [UIView]()
    
    init(stations: [Station], bounds: CGRect) {
        self.stations = stations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func stationSelected(_ s: Station) {
        PLAYBACK_MANAGER.station = s
        PLAYBACK_MANAGER.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.titleView = DefaultTopItemLabel(text: "Streams")
        
        var vs: [UIView] = [UIView]()
        for s in stations {
            let v = StationView(frame: view.frame)
            v.station = s
            v.delegate = self
            vs.append(v)
        }
        for v in vs {
            view.addSubview(v)
        }
        views = vs
    }
    
    override func viewDidLayoutSubviews() {
        let f = view.frame
        let h = (f.height - MINIPLAYER_HEIGHT - DEFAULT_MARGIN_PX) / CGFloat(views.count)
        
        for (i, v) in views.enumerated() {
            v.frame = CGRect(x: 0,
                             y: CGFloat(i * Int(h)), // cast to Int to make sure i == 0 is handled correctly
                             width: f.width,
                             height: h)
        }
    }
    
    private class StationView: UIView {
        
        var delegate: StationViewDelegate?
        
        var station: Station? = nil {
            didSet {
                image.image = station?.image
                text.text = station?.title
            }
        }
        
        var image: UIImageView = {
            let result = OJORoundedImageView()
            result.contentMode = .scaleAspectFit
            return result
        }()
        
        var text: UILabel = {
            let result = UILabel()
            result.text = DEFAULT_PLACEHOLDER_TEXT
            result.font = UIFont(name: DEFAULT_FONT_BOLD, size: 18)
            result.textColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0) // #595959 TODO extract when you use it enough throughout the app to share it and give it a name
            return result
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = DEFAULT_VC_BACKGROUND_COLOR
            
            let gr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            addGestureRecognizer(gr)
            isUserInteractionEnabled = true
            
            addSubview(image)
            addSubview(text)
        }
        
        func handleTap() {
            delegate?.stationSelected(station!)
        }
        
        override func layoutSubviews() {
            
            let imageWH = frame.height - 2 * DEFAULT_MARGIN_PX
            image.frame = CGRect(x: DEFAULT_MARGIN_PX,
                                 y: DEFAULT_MARGIN_PX,
                                 width: imageWH,
                                 height: imageWH)
            
            text.sizeToFit()
            let textHeight = text.frame.height

            text.frame = CGRect(x: frame.width / 2,
                                y: frame.height / 2 - text.frame.height / 2,
                                width: frame.width / 2,
                                height: textHeight)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

protocol StationViewDelegate {
    func stationSelected(_ s: Station)
}
