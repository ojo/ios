//
//  NewsCollectionsViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import UIKit

class NewsFeedViewController: HidingNavBarCollectionViewController {

    let service = NewsItemService()
    
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
        
        service.subscribe(self)
       
        self.view.backgroundColor = UIColor.ojo_grey_59
        navigationController?.navigationBar.topItem?.titleView = DefaultTopItemLabel("OJO")
        
        collectionView?.register(NewsFeedCollectionViewCell.self,
                                 forCellWithReuseIdentifier: NewsFeedCollectionViewCell.REUSE_IDENT)
        
        if let v = collectionView {
            v.backgroundColor = UIColor.ojo_defaultVCBackground
            v.delaysContentTouches = false
        }
        
        service.want(itemsBefore: nil)
    }
}

extension NewsFeedViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return service.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewsFeedCollectionViewCell.REUSE_IDENT,
            for: indexPath)

        if let c = cell as? NewsFeedCollectionViewCell {
            c.item = service.item(at: indexPath.row)
            return c
        }
        return cell // TODO when does this happen?
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isHighlighted = true
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.isHighlighted = false
    }
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
/* TODO   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return TODO
    }
 */
}

extension NewsFeedViewController: NewsItemServiceDelegate {
    func serviceRefreshed() {
        collectionView?.reloadData()
    }
}
