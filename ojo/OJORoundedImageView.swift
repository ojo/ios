//
//  OJORoundedImageView.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/29/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit

class OJORoundedImageView: UIImageView {

    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        layer.cornerRadius = DEFAULT_CORNER_RADIUS
        clipsToBounds = true
        layer.borderColor = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.0).cgColor
        layer.borderWidth = 1
        contentMode = .scaleAspectFit
    }
}
