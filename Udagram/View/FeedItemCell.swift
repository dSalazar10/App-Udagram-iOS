//
//  FeedItemCell.swift
//  Udagram
//
//  Created by Daniel Salazar on 7/10/19.
//  Copyright © 2019 Daniel Salazar. All rights reserved.
//

import UIKit

// Each Table View Cell will have a FeedItem
class FeedItemCell: UITableViewCell {
    // The FeeItem's Image
    @IBOutlet weak var feedImage: UIImageView!
    // The FeeItem's Caption
    @IBOutlet weak var feedCaption: UITextView!
    // Constructs the Cell
    func configure(image: UIImage, caption: String) {
        feedImage.image = image
        feedCaption.text = caption
    }
}
