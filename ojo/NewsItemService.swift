//
//  NewsItemService.swift
//  ojo
//
//  Created by Brian Tiger Chow on 1/7/17.
//  Copyright © 2017 TTRN. All rights reserved.
//

import Alamofire
import Argo

protocol NewsItemServiceDelegate {
    func serviceRefreshed()
}

class NewsItemService {

    var count: Int {
        get {
            return items.count
        }
    }

    private let API_URL = API_HOST + "/api/v0/news_items"

    // NB: don't expose! client shouldn't modify.
    private var items = [NewsItem]() {
        didSet {
            delegates.forEach { $0.serviceRefreshed() }
        }
    }
    

    private var delegates = [NewsItemServiceDelegate]()

    init() {}

    func item(at index: Int) -> NewsItem {
        return items[index]
    }

    // makes news items available locally
    func want(itemsBefore item: NewsItem?) {
        foo()
    }

    func subscribe(_ d: NewsItemServiceDelegate) {
        delegates.append(d)
    }

    private func foo() {
        Alamofire.request(API_URL).responseJSON { response in
            if let json: Any = response.result.value {
                if let items = self.parse(array: json) {
                    self.items = items
                }
            }
        }
    }

    private func parse(array data: Any) -> [NewsItem]? {
        let decodedArray: Decoded<[JSON]> = JSON(data) <|| "data"
        guard let array = decodedArray.value else {
            print(decodedArray.error.debugDescription)
            return nil
        }
        let decodedItems: [Decoded<NewsItem>] = array.map { NewsItem.decode($0) }
        var items = [NewsItem]()
        for decoded in decodedItems {
            guard let item = decoded.value else {
                print(decoded.error.debugDescription)
                continue
            }
            items.append(item)
        }
        return items
    }

}
