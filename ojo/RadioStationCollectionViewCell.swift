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
    var thumbnail: UIImageView = {
        let result = UIImageView()
        return result
    }()
    
    var textLabel: UILabel = {
        let result = UILabel()
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
        // brian - layout views here
        thumbnail.frame = CGRect(x: 10, y: 10, width: 80, height: 80)
        textLabel.frame = CGRect(x: 100, y: 20, width: 120, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
