//
//  NewsItemViewController.swift
//  ojo
//
//  Created by Boris Suvorov on 12/26/16.
//  Copyright © 2016 TTRN. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class NewsItemViewController : UIViewController {
    var newsItem: NewsItem?
    
    private let container: UIScrollView = {
        let v = UIScrollView()
        return v
    }()
    
    // TODO drophead, subtitle, caption, ad
    
    private let straphead: UILabel = {
        let v = UILabel()
        v.font = UIFont(name: DEFAULT_FONT, size: 14)
        v.textColor = UIColor.ojo_grey_59 // FIXME: Design says #8D8D8D
        return v
    }()

    private let image: UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = DEFAULT_CORNER_RADIUS
        return v
    }()

    private let titleView: UILabel = {
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
    
    private let body: WKWebView = {
        let v = WKWebView()
        //        v.font = UIFont(name: DEFAULT_FONT, size: 14)
        // v.textColor = UIColor.ojo_grey_84
        return v
    }()
    
    init(_ newsItem: NewsItem) {
        self.newsItem = newsItem
        super.init(nibName: nil, bundle: nil)
        bindDataToViews()
    }
    
    func bindDataToViews() {
        guard let newsItem = newsItem else { return }
        category.text = newsItem.category
        titleView.text = newsItem.title
        body.loadHTMLString(newsItem.body, baseURL: nil)
        straphead.text = newsItem.straphead
        
        if let c = UIColor(hexString: newsItem.photo.dominantColor),
            let ci = UIImage.from(color: c),
            let url = URL(string: newsItem.photo.URL) {
            image.af_setImage(withURL: url, placeholderImage: ci)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ojo_defaultVCBackground
        
        let subviews = [straphead, image, titleView, body, timestamp, category]
        for v in subviews {
            container.addSubview(v)
        }
        view.addSubview(container)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
        
        let fullWidth = view.frame.width - 2 * DEFAULT_MARGIN_PX
        
        straphead.frame = CGRect(x: DEFAULT_MARGIN_PX,
                                 y: topLayoutGuide.length + DEFAULT_MARGIN_PX,
                                 width: fullWidth,
                                 height: 40) // TODO FIXME
        
        image.frame = CGRect(x: DEFAULT_MARGIN_PX,
                             y: straphead.frame.maxY + DEFAULT_MARGIN_PX,
                             width: fullWidth,
                             height: fullWidth/THE_GOLDEN_RATIO)
        
        category.frame = CGRect(x: DEFAULT_MARGIN_PX,
                                y: image.frame.maxY + DEFAULT_MARGIN_PX,
                                width: fullWidth,
                                height: 40) // FIXME TODO
        
        titleView.frame = CGRect(x: DEFAULT_MARGIN_PX,
                                 y: category.frame.maxY,
                                 width: fullWidth,
                                 height: 100) // TODO FIXME
        
        body.frame = CGRect(x: DEFAULT_MARGIN_PX,
                            y: titleView.frame.maxY + DEFAULT_MARGIN_PX,
                            width: fullWidth,
                            height: 100)

        container.contentSize = CGSize(width: view.bounds.width, height: body.frame.maxY)
    }
}
