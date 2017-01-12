//
//  OJORoundedImageView.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/29/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit

class OJORoundedImageView: UIImageView {

    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.cornerRadius = DEFAULT_CORNER_RADIUS
        clipsToBounds = true
        layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
        layer.borderWidth = 1
        contentMode = .scaleAspectFit
    }
}
