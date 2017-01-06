//
//  NewsCollectionsViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit
import HidingNavigationBar

class NewsFeedViewController: UICollectionViewController {
    
    let REUSE_IDENT = "NewsFeedCollectionViewCell"
    
    var hidingNavBarManager: HidingNavigationBarManager?
    
    let newsItems = NEWS_ITEMS
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor.ojo_grey
        navigationController?.navigationBar.topItem?.titleView = DefaultTopItemLabel("OJO")
        
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
