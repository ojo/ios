//
//  EventsItemService.swift
//  ojo
//
//  Created by Narayana Reddy on 17/02/17.
//  Copyright © 2017 TTRN. All rights reserved.
//


import Alamofire
import Argo

protocol EventsItemServiceDelegate {
    func serviceRefreshed()
}

class EventsItemService {
    
    var count: Int {
        get {
            return items.count
        }
    }
    
    private let API_URL = API_HOST + "/api/v0/news_items"
    
    // NB: don't expose! client shouldn't modify.
    private var items = [EventItem]() {
        didSet {
            delegates.forEach { $0.serviceRefreshed() }
        }
    }
    
    
    private var delegates = [EventsItemServiceDelegate]()
    
    init() {}
    
    func item(at index: Int) -> EventItem? {
        return items[index]
    }
    
    // makes news items available locally
    func want(itemsBefore item: EventItem?) {
        foo()
    }
    
    func subscribe(_ d: EventsItemServiceDelegate) {
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
    
    private func parse(array data: Any) -> [EventItem]? {
        let decodedArray: Decoded<[JSON]> = JSON(data) <|| "data"
        guard let array = decodedArray.value else {
            print(decodedArray.error.debugDescription)
            return nil
        }
        let decodedItems: [Decoded<EventItem>] = array.map { EventItem.decode($0) }
        var items = [EventItem]()
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
