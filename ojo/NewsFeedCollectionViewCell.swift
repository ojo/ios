//
//  NewsFeedCollectionViewCell.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/6/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import UIKit
import SwiftHEXColors

class NewsFeedCollectionViewCell: UICollectionViewCell {
    static let REUSE_IDENT = "NewsFeedCollectionViewCell"
    
    var item: NewsItem? = nil {
        didSet {
            guard let item = item else { return }
            
            let s = CGSize(width: 1, height: 1)
            if let c = UIColor(hexString: item.photo.dominantColor) {
                image.image = UIImage.from(color: c, withSize: s)
            }
            _ = fetchImage(item.photo.URL).then { image -> Void in
                self.image.image = image
            }
            
            title.text = item.title
            category.text = item.category
        }
    }
    
    private let image: UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = DEFAULT_CORNER_RADIUS
        return v
    }()
    
    private let title: UILabel = {
        let v = UILabel()
        v.font = UIFont(name: DEFAULT_FONT_BOLD, size: 26)
        v.textColor = UIColor.black
        return v
    }()
    
    private let category: UILabel = {
        let v = UILabel()
        v.textColor = UIColor.ojo_red
        v.font = UIFont(name: DEFAULT_FONT_BOLD, size: 14)
        return v
    }()
    
    private let timestamp: UILabel = {
        let v = UILabel()
        v.font = UIFont(name: DEFAULT_FONT, size: 14)
        v.textColor = UIColor.ojo_grey_84
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(category)
        contentView.addSubview(timestamp)
    }
    
    override func layoutSubviews() {
        let fullWidth = frame.width - 2 * DEFAULT_MARGIN_PX
        image.frame = CGRect(x: DEFAULT_MARGIN_PX,
                             y: DEFAULT_MARGIN_PX,
                             width: fullWidth,
                             height: fullWidth/THE_GOLDEN_RATIO)
        let underImage = image.frame.maxY + 2 * DEFAULT_MARGIN_PX
        category.frame = CGRect(x: DEFAULT_MARGIN_PX,
                                y: underImage,
                                width: fullWidth,
                                height: 25)
        category.sizeToFit()
        timestamp.frame = CGRect(x: category.frame.maxX + 2 * DEFAULT_MARGIN_PX,
                                 y: underImage,
                                 width: 100,
                                 height: 25)
        timestamp.sizeToFit()
        title.frame = CGRect(x: DEFAULT_MARGIN_PX,
                             y: category.frame.maxY + 2 * DEFAULT_MARGIN_PX,
                             width: fullWidth,
                             height: 200)
        title.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
