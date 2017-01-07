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
       
        self.view.backgroundColor = UIColor.ojo_grey_59
        navigationController?.navigationBar.topItem?.titleView = DefaultTopItemLabel("OJO")
        
        collectionView?.register(NewsFeedCollectionViewCell.self,
                                 forCellWithReuseIdentifier: NewsFeedCollectionViewCell.REUSE_IDENT)
        
        if let v = collectionView {
            hidingNavBarManager = HidingNavigationBarManager(viewController: self,
                                                             scrollView: v)
            v.backgroundColor = UIColor.white
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

extension NewsFeedViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return NEWS_ITEMS.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewsFeedCollectionViewCell.REUSE_IDENT,
            for: indexPath)

        if let c = cell as? NewsFeedCollectionViewCell {
            c.item = NEWS_ITEMS[indexPath.row]
            return c
        }
        return cell // TODO when does this happen?
    }
}
