//
//  FeedItems.swift
//  Udagram
//
//  Created by Daniel Salazar on 7/10/19.
//  Copyright © 2019 Daniel Salazar. All rights reserved.
//

import UIKit

//  Controller for the TableView
// This downloads the images  and uploads the feed data into a table
class FeedItems: UITableViewController {
    // The Table View we are using
    @IBOutlet var feedItemTableView: UITableView!
    // A collection of feed items
    var feedResult: [FeedItem] = []
    // HTTP request to the RestAPI
    let queryService = QueryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedItemTableView.tableFooterView = UIView()
        self.clearsSelectionOnViewWillAppear = false
        // Start showing network spinning gear in status bar during download
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        // Make an HTTP request to the RestAPI Server
        queryService.getFeed() { results, errorMessage in
            // Now that the feed has been downloaded, stop showing network
            // spinning gear in status bar
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            // If we managed to get the feed, put all the feedItems
            // into the local variable and reload the table
            if let results = results {
                self.feedResult = results
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPoint.zero, animated: false)
            }
            // Log any errors received
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
    }
    // Takes a URL and downloads the image
    func downloadImage(url: URL) -> UIImage? {
        let data = try? Data(contentsOf: url)
        if let imageData = data {
            return UIImage(data: imageData)
        }
        return nil
    }

    // MARK: - Table view data source
    // Number of Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // Height of each cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 512.0
    }
    // Number of rows is equal to the number of feed items
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return feedResult.count
    }
    // This is where we construct each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell using the Prototype Cell in the storyboard
        let cell = feedItemTableView.dequeueReusableCell(withIdentifier: "FeedItemCell", for: indexPath) as! FeedItemCell
        // Update the current cell with the respective element in the feedResult
        let feed = feedResult[indexPath.row]
        // Try to download the image. This could fail
        if let image: UIImage = downloadImage(url: feed.url) {
            cell.configure(image: image, caption: feed.caption)
        }
        return cell
    }
}
