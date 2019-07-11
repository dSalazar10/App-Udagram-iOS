//
//  FeedItem.swift
//  Udagram
//
//  Created by Daniel Salazar on 7/10/19.
//  Copyright © 2019 Daniel Salazar. All rights reserved.
//

import Foundation.NSURL

// Model for the Feed Item
class FeedItem {
    // Keep track of id for the row
    let id: Int;
    // URL of the image
    let url: URL;
    // Caption that goes with the image
    let caption: String;
    // Constructs a Feed Object
    init(id: Int, url: URL, caption: String) {
        self.id = id
        self.url = url
        self.caption = caption
    }
}
