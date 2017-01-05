//
//  OfflineOverlayView.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/4/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

class OfflineOverlayView: UIView {
    let background: UIView = {
        // intercepts touch events
        let v = UIButton()
        v.backgroundColor = UIColor.white
        v.alpha = 0.85
        return v

    }()
    
    let label: UIView = {
        let v = UILabel()
        v.text = "You're Offline"
        v.textColor = UIColor.ojo_grey
        v.backgroundColor = UIColor.clear
        v.font = UIFont(name: DEFAULT_FONT_BOLD, size: 22)
        v.textAlignment = .center
        return v
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        
        addSubview(background)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        background.frame = bounds
        label.frame = CGRect(x: 0, y: bounds.height/4, width: bounds.width, height: 100)
    }
    
}
