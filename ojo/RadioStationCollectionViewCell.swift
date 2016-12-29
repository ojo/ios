//
//  RadioStationCollectionViewCell.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class RadioStationCollectionViewCell : UICollectionViewCell {
        
    // FIXME(btc): rename parameter. is it the frame or bounds?
    class func cellHeight(givenBounds bounds: CGRect) -> CGFloat {
        return bounds.width / 2 - 2 * DEFAULT_MARGIN_PX
    }

    var thumbnail: UIImageView = {
        let result = UIImageView()
        result.layer.cornerRadius = 6
        result.clipsToBounds = true
        result.layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
        result.layer.borderWidth = 1
        result.contentMode = .scaleAspectFit
        return result
    }()
    
    var textLabel: UILabel = {
        let result = UILabel()
        result.text = DEFAULT_PLACEHOLDER_TEXT
        result.font = UIFont(name: DEFAULT_FONT_BOLD, size: 18)
        result.textColor = UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0) // 595959 TODO extract when you recognize name
        return result
    }()
    
    public var station: Station? = nil {
        didSet {
            textLabel.text = station?.title
            thumbnail.image = station?.image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = DEFAULT_VC_BACKGROUND_COLOR
        self.contentView.addSubview(thumbnail)
        self.contentView.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        // TODO(btc): layout views
        // TODO(btc): station name goes in horizontal center 
        
        let imageWidthHeight = RadioStationCollectionViewCell.cellHeight(givenBounds: frame)
        thumbnail.frame = CGRect(x: DEFAULT_MARGIN_PX,
                                 y: DEFAULT_MARGIN_PX,
                                 width: imageWidthHeight,
                                 height: imageWidthHeight)
        
        textLabel.sizeToFit()
        let textHeight = textLabel.frame.height
        
        let textX = self.frame.width / 2
        let textY = self.frame.height / 2
        textLabel.frame = CGRect(x: textX,
                                 y: textY,
                                 width: 120,
                                 height: textHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
