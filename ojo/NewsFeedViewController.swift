//
//  NewsCollectionsViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit

class NewsFeedViewController: HidingNavBarCollectionViewController {

    let newsItems = NEWS_ITEMS
    
    init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width, height: frame.width)
        super.init(collectionViewLayout: layout)
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
            v.backgroundColor = UIColor.white
        }
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
