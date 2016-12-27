//
//  NewsCollectionsViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class NewsCollectionsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(radioButtonPressed))
        self.view.backgroundColor = UIColor.gray
    }
    
    @objc private func radioButtonPressed() {
        let vc = RadioStationCollectionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
}
