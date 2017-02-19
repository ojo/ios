//
//  NowCollectionViewCell.swift
//  ojo
//
//  Created by Brian Tiger Chow on 2/19/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit

class NowCollectionViewCell: UICollectionViewCell {
    static let reuseID: String = "NowCollectionViewCell"

    var data: NewsItem? {
        didSet {
            guard let data = data else {
                backgroundColor = .random
                return
            }
            backgroundColor = UIColor(hexString: data.photo.dominantColor)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
