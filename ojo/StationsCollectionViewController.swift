//
//  RadioStationCollectionViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit

class StationsCollectionViewController : HidingNavBarCollectionViewController {
    
    let REUSE_IDENTIFIER = "RadioStationCollectionViewCell"
    
    var stations: [Station]!
    
    init(withStations stations: [Station], rect: CGRect) {
        self.stations = stations
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: rect.width,
                                     height: RadioStationCollectionViewCell.cellHeight(givenBounds: rect))
        super.init(collectionViewLayout: flowLayout)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.ojo_defaultVCBackground
        navigationController?.navigationBar.topItem?.titleView = DefaultTopItemLabel("OJO Streams")

        collectionView?.register(RadioStationCollectionViewCell.self,
                                 forCellWithReuseIdentifier: REUSE_IDENTIFIER)
    }
}


// MARK: - UICollectionViewDataSource
extension StationsCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: REUSE_IDENTIFIER, for: indexPath)
        
        if let radioCell = cell as? RadioStationCollectionViewCell {
            radioCell.station = stations[indexPath.row]
            return radioCell
        }

        return cell
    }
}
