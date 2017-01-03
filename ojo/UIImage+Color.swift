//
//  UIImage+Color.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/2/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

extension UIImage {
    static func from(color: UIColor, withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            return image
        }
        return nil
    }
}
