//
//  Utils.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

let DEFAULT_MARGIN_PX = CGFloat(6)
let DEFAULT_PLACEHOLDER_TEXT = "REPLACE ME"
let DEFAULT_FONT = "HelveticaNeue"
let DEFAULT_FONT_BOLD = "HelveticaNeue-Bold"

extension UIColor {
    
    // you can use http://uicolor.xyz/#/hex-to-ui to convert hex to UIColor!
    
    static var ojo_defaultVCBackground: UIColor {
        get {
            return UIColor.white
        }
    }
    static var ojo_grey: UIColor {
        get {
            return UIColor(red:0.35, green:0.35, blue:0.35, alpha:1.0) // #595959
        }
    }
    static var ojo_red: UIColor {
        get {
            return UIColor(red:0.85, green:0.00, blue:0.00, alpha:1.0) // #D80000
        }
    }
    static var ojo_tint_for_selected_view: UIColor {
        get {
            return UIColor(red:0.9, green:0.9, blue:0.9, alpha:1.0)
        }
    }
}
