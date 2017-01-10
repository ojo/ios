//
//  StationView.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/1/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

protocol StationViewDelegate {
    func stationSelected(_ s: Station)
}

class StationView: UIView {
    
    private var delegate: StationViewDelegate?
    
    private var station: Station?

    private let image: UIImageView = {
        let result = OJORoundedImageView()
        return result
    }()
    
    private let imageMask: UIView = {
        let v = OJORoundedImageView()
        v.alpha = 0.5
        v.backgroundColor = UIColor.ojo_grey_59
        return v
    }()
    
    private let text: UILabel = {
        let result = UILabel()
        result.text = DEFAULT_PLACEHOLDER_TEXT
        result.font = UIFont(name: DEFAULT_FONT_BOLD, size: 18)
        result.textColor = UIColor.ojo_grey_59
        return result
    }()
    
    convenience init(frame: CGRect, station: Station, delegate: StationViewDelegate) {
        self.init(frame: frame)
        
        self.station = station
        self.delegate = delegate
        
        image.image = station.image
        text.text = station.title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ojo_defaultVCBackground
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        gr.cancelsTouchesInView = false // allows us to tint the views in response to touch
        addGestureRecognizer(gr)
        
        addSubview(image)
        addSubview(text)
    }
    
    func handleTap() {
        delegate?.stationSelected(station!)
    }
    
    override func layoutSubviews() {
        
        let imageWH = min(frame.height - 2 * DEFAULT_MARGIN_PX, frame.width/2 - 2 * DEFAULT_MARGIN_PX)
        image.frame = CGRect(x: DEFAULT_MARGIN_PX,
                             y: DEFAULT_MARGIN_PX,
                             width: imageWH,
                             height: imageWH)
        
        imageMask.frame = image.frame
        
        text.sizeToFit()
        let textHeight = text.frame.height
        
        text.frame = CGRect(x: frame.width / 2,
                            y: frame.height / 2 - text.frame.height / 2,
                            width: frame.width / 2,
                            height: textHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        addSubview(imageMask)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        imageMask.removeFromSuperview()
    }
}
