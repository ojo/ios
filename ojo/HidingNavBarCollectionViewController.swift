//
//  HidingNavBarCollectionViewController.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/7/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import HidingNavigationBar
import UIKit

class HidingNavBarCollectionViewController: UICollectionViewController {
    
    private var hidingNavBarManager: HidingNavigationBarManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let v = collectionView {
            hidingNavBarManager = HidingNavigationBarManager(viewController: self,
                                                             scrollView: v)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        return true
    }
}
