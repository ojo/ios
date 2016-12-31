//
//  DefaultTopItemLabel.swift
//  ojo
//
//  Created by Brian Tiger Chow on 12/27/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit

class DefaultTopItemLabel: UILabel {
    
    convenience init(text: String) {
        self.init()
        self.setup()
        self.text = text
        sizeToFit() // FIXME(btc): I'm not sure if this is the right place to do this!
    }
    
    func setup() {
        font = UIFont(name: DEFAULT_FONT_BOLD, size: 22)
        textColor = UIColor.ojo_red
    }
}
