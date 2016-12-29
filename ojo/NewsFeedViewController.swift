//
//  NewsCollectionsViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class NewsFeedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO(btc): extract custom button
        let radio = UIImage(named: "radio")!
        let button: UIButton = UIButton(type: .custom)
        button.bounds = CGRect(x: 0, y: 0, width: radio.size.width, height: radio.size.height)
        button.setImage(radio, for: .normal)
        button.addTarget(self, action: #selector(radioButtonPressed), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
        
        self.view.backgroundColor = DEFAULT_VC_BACKGROUND_COLOR
    }
    
    @objc private func radioButtonPressed() {
        let vc = StationsViewController(withStations: STATIONS, rect: view.bounds) // FIXME(btc): view.frame?
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}
