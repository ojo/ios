//
//  NowViewController.swift
//  ojo
//
//  Created by Brian Tiger Chow on 2/19/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import TRMosaicLayout
import UIKit
import FacebookShare

class NowCollectionViewController: UICollectionViewController {

    let service = NewsItemService()

    init() {
        let layout = TRMosaicLayout()
        super.init(collectionViewLayout: layout)
        layout.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        service.subscribe(self)

        collectionView?.register(NowCollectionViewCell.self,
                                 forCellWithReuseIdentifier: NowCollectionViewCell.reuseID)

        if let v = collectionView {
            v.backgroundColor = UIColor.ojo_defaultVCBackground
            v.delaysContentTouches = true // explicitly. for now.
            if #available(iOS 10.0, *) {
                v.prefetchDataSource = self
            }
        }

        service.loadItems() // eager load some initial entries
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let c = collectionView.dequeueReusableCell(withReuseIdentifier: NowCollectionViewCell.reuseID, for: indexPath)
        if let cc = c as? NowCollectionViewCell {
            cc.data = service.item(at: indexPath.item)
        }
        return c
    }
}

extension NowCollectionViewController { // UICollectionViewDelegate

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return service.count
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let content = service.item(at: indexPath.item).facebookLinkShareContent else { return }
        let dialog = ShareDialog(content: content)
        dialog.mode = .native
        dialog.failsOnInvalidData = true
        dialog.completion = { result in
            Log.info?.trace()
        }
        try? dialog.show()
    }
}

extension NowCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // TODO
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // TODO
    }
}

extension NowCollectionViewController: NewsItemServiceDelegate {
    func serviceRefreshed() {
        collectionView?.reloadData()
    }
}

extension NowCollectionViewController: TRMosaicLayoutDelegate {
    func heightForSmallMosaicCell() -> CGFloat {
        return 200
    }

    func collectionView(_ collectionView: UICollectionView,
                        mosaicCellSizeTypeAtIndexPath indexPath: IndexPath) -> TRMosaicCellType {
        return indexPath.item % 3 == 0 ? .big : .small
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: TRMosaicLayout,
                        insetAtSection: Int) -> UIEdgeInsets {
        return .zero
    }
}

extension NewsItem {
    var facebookLinkShareContent: LinkShareContent? {
        guard let imageURL = URL(string: photo.URL) else { return nil }
        let url = imageURL
        return LinkShareContent(url: url, title: title, imageURL: imageURL)
    }
}
