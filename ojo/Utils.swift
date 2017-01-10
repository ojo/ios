//
//  Utils.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

let API_HOST = "https://api.ojo.world"

let ESTIMATED_STREAM_LATENCY_IN_SECS = 23
let DEFAULT_MARGIN_PX: CGFloat = 6
let DEFAULT_PLACEHOLDER_TEXT = "REPLACE ME"
let DEFAULT_FONT = "HelveticaNeue"
let DEFAULT_FONT_BOLD = "HelveticaNeue-Bold"
let DEFAULT_CORNER_RADIUS: CGFloat = 6
let THE_GOLDEN_RATIO: CGFloat = 1.61803398875

let RELEASE_PHASE: UInt = 2

extension UIColor {
    
    // you can use http://uicolor.xyz/#/hex-to-ui to convert hex to UIColor!
    
    static var ojo_defaultVCBackground: UIColor {
        get {
            return UIColor.white
        }
    }
    
    static var ojo_grey_84: UIColor {
        get {
            return UIColor(red:0.52, green:0.52, blue:0.52, alpha:1.0) // #848484
        }
    }
    static var ojo_grey_59: UIColor {
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
