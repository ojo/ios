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
            title.text = data.title

            let urlAtTimeOfRequest: String = data.photo.URL
            _ = UIImage.promise(url: data.photo.URL).then { image -> Void in
                guard let currentURL = self.data?.photo.URL, urlAtTimeOfRequest == currentURL else { return }
                self.image.image = image
            }
        }
    }

    let title: UILabel = {
        let v = UILabel()
        v.textColor = .ojo_defaultVCBackground
        v.font = UIFont.defaultBoldFont(ofSize: 16)
        v.lineBreakMode = .byWordWrapping
        v.numberOfLines = 0
        return v
    }()

    let image: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        for v: UIView in [image, title] { // order matters
            addSubview(v)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        image.frame = bounds

        let titleMargin: CGFloat = 5
        let titleSize = title.sizeThatFits(bounds.insetBy(dx: titleMargin, dy: titleMargin).size)
        let titleOrigin = CGPoint(x: titleMargin,
                                  y: bounds.height - titleSize.height - titleMargin)
        title.frame = CGRect(origin: titleOrigin,
                             size: titleSize)
    }

    override func prepareForReuse() {
        image.image = nil
        title.text = ""
    }
}
