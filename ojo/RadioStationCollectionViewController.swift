//
//  RadioStationCollectionViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class RadioStationCollectionViewController : UICollectionViewController {
    let reuseIdentifier = "radioCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = DEFAULT_VC_BACKGROUND_COLOR
        collectionView?.register(RadioStationCollectionViewCell.self,
                                 forCellWithReuseIdentifier: reuseIdentifier)
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
