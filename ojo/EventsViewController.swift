//
//  EventsViewController.swift
//  ojo
//
//  Created by Narayana Reddy on 17/02/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit


class EventsViewController: HidingNavBarCollectionViewController {
    
        let serviceEvent = EventsItemService()
        
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
            
            serviceEvent.subscribe(self)
            
            self.view.backgroundColor = UIColor.ojo_grey_59
            navigationController?.navigationBar.topItem?.titleView = DefaultTopItemLabel("OJO")
            
            collectionView?.register(NewsFeedCollectionViewCell.self,
                                     forCellWithReuseIdentifier: NewsFeedCollectionViewCell.REUSE_IDENT)
            
            if let v = collectionView {
                v.backgroundColor = UIColor.ojo_defaultVCBackground
                v.delaysContentTouches = false
            }
            
            serviceEvent.want(itemsBefore: nil)
        }
    }
    
    extension EventsViewController {
        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        override func collectionView(_ collectionView: UICollectionView,
                                     numberOfItemsInSection section: Int) -> Int {
            return serviceEvent.count
        }
        
        override func collectionView(_ collectionView: UICollectionView,
                                     cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: EventsViewCollectionViewCell.REUSE_IDENT,
                for: indexPath)
            if let c = cell as? EventsViewCollectionViewCell {
                c.item = serviceEvent.item(at: indexPath.row)
                return c
            }
            return cell // TODO when does this happen?
        }
        
        override func collectionView(_ collectionView: UICollectionView,
                                     didHighlightItemAt indexPath: IndexPath) {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.isHighlighted = true
            
        }
        
        override func collectionView(_ collectionView: UICollectionView,
                                     didUnhighlightItemAt indexPath: IndexPath) {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.isHighlighted = false
        }
        
        override func collectionView(_ collectionView: UICollectionView,
                                     didSelectItemAt indexPath: IndexPath) {
            guard let item = serviceEvent.item(at: indexPath.row) else {
                let msg = "User selected item at index \(indexPath), but it wasn't available in News Service"
                Log.error?.message(msg)
                return
            }
//            let vc = EventsViewController(item)
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
        /* TODO   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return TODO
         }
         */
    }
    
    extension EventsViewController: EventsItemServiceDelegate {
        func serviceRefreshed() {
            collectionView?.reloadData()
        }
}
