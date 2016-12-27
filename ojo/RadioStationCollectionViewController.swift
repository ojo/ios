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

class RadioStationCollectionViewController : UICollectionViewController {
    let reuseIdentifier = "radioCell"
    var hidingNavBarManager: HidingNavigationBarManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = DEFAULT_VC_BACKGROUND_COLOR
        collectionView?.register(RadioStationCollectionViewCell.self,
                                 forCellWithReuseIdentifier: reuseIdentifier)
        
        if let scrollView = self.collectionView {
            hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: scrollView)
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
extension RadioStationCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return Stations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let radioCell = cell as? RadioStationCollectionViewCell {
            radioCell.station = Stations[indexPath.row]
            return radioCell
        }

        return cell
    }
}
