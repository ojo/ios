//
//  NowNavigationController.swift
//  ojo
//
//  Created by Brian Tiger Chow on 2/19/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

class NowNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ojo_defaultVCBackground
        setNavigationBarHidden(true, animated: false)
    }
}
