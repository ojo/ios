//
//  UIView.swift
//  ojo
//
//  Created by Brian Tiger Chow on 3/16/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

extension UIView {
    func computedSize(width: CGFloat) -> CGSize {
        let s = CGSize(width: width, height: .greatestFiniteMagnitude)
        return sizeThatFits(s)
    }
}
