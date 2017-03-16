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

    static func sizeFor(newsItem: NewsItem, givenWidth w: CGFloat) -> CGSize {
        let h = w
        // TODO
        return CGSize(width: w, height: h)
    }
    
    // TODO add class function to determine height for cell based on content and frame
    var item: NewsItem? = nil {
        didSet {
            guard let item = item else { return }
            
            if let c = UIColor(hexString: item.photo.dominantColor) {
                image.image = UIImage.from(color: c)
            }
            
            let url: String = item.photo.URL
            _ = UIImage.promise(url: item.photo.URL).then { image -> Void in
                guard let currentURL = self.item?.photo.URL, url == currentURL else { return }
                self.image.image = image
            }
            
            title.text = item.title
            category.text = item.category
            timestamp.text = "1 hour ago" // TODO use a library for this
            setNeedsLayout()
        }
    }
    
    private let image: UIImageView = {
        let v = OJORoundedImageView()
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    private let title: UILabel = {
        let v = UILabel()
        v.font = UIFont(name: DEFAULT_FONT_BOLD, size: 26)
        v.textColor = UIColor.black
        v.highlightedTextColor = UIColor.ojo_red
        v.numberOfLines = 10
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
    
    override var isHighlighted: Bool {
        didSet {
            title.isHighlighted = isHighlighted
            image.isHighlighted = isHighlighted
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(category)
        contentView.addSubview(timestamp)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let fullWidth = bounds.width - 2 * DEFAULT_MARGIN_PX
        image.frame = CGRect(x: DEFAULT_MARGIN_PX,
                             y: DEFAULT_MARGIN_PX,
                             width: fullWidth,
                             height: fullWidth/THE_GOLDEN_RATIO)
        let underImage = image.bounds.maxY + 2 * DEFAULT_MARGIN_PX
        
        let cs = category.computedSize(width: fullWidth)
        category.frame = CGRect(x: DEFAULT_MARGIN_PX,
                                y: underImage,
                                width: cs.width,
                                height: cs.height)

        let tss = timestamp.computedSize(width: fullWidth)
        timestamp.frame = CGRect(x: category.bounds.maxX + 2 * DEFAULT_MARGIN_PX,
                                 y: underImage,
                                 width: tss.width,
                                 height: tss.height)
        
        title.frame = CGRect(x: DEFAULT_MARGIN_PX,
                             y: category.frame.maxY + DEFAULT_MARGIN_PX,
                             width: title.computedSize(width: fullWidth).width,
                             height: title.computedSize(width: fullWidth).height)
    }
    
    override func prepareForReuse() {
        image.image = UIImage.from(color: UIColor.ojo_grey_59)
        category.text = nil
        title.text = nil
        timestamp.text = nil
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
