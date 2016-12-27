//
//  RadioStationCollectionViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit
import HidingNavigationBar

class StationsViewController : UICollectionViewController {
    
    let REUSE_IDENTIFIER = "RadioStationCollectionViewCell"
    
    var hidingNavBarManager: HidingNavigationBarManager?
    
    init(boundsWidth: CGFloat) {
        let flowLayout = UICollectionViewFlowLayout()
        let h = RadioStationCollectionViewCell.cellHeight(givenFrameWidth: boundsWidth)
        flowLayout.itemSize = CGSize(width: boundsWidth, height: h)
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = DEFAULT_VC_BACKGROUND_COLOR
        
        navigationController?.navigationBar.topItem?.titleView = DefaultTopItemLabel(text: "Streams")

        collectionView?.register(RadioStationCollectionViewCell.self,
                                 forCellWithReuseIdentifier: REUSE_IDENTIFIER)
        
        if let v = collectionView {
            hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: v)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        hidingNavBarManager?.viewDidLayoutSubviews()
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


// MARK: - UICollectionViewDataSource
extension StationsViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return Stations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath)
        if let radioCell = cell as? RadioStationCollectionViewCell {
            radioCell.station = Stations[indexPath.row]
            return radioCell
        }

        return cell
    }
}
