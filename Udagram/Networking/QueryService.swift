//
//  QueryService.swift
//  Udagram
//
//  Created by Daniel Salazar on 7/10/19.
//  Copyright © 2019 Daniel Salazar. All rights reserved.
//

import Foundation

class QueryService {
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([FeedItem]?, String) -> ()
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    var feeds: [FeedItem] = []
    var errorMessage = ""
    
    func getFeed(completion: @escaping QueryResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "http://udagram-restapi-prod.us-east-2.elasticbeanstalk.com/api/v0/feed") {
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateFeed(data)
                    DispatchQueue.main.async {
                        completion(self.feeds, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    fileprivate func updateFeed(_ data: Data) {
        var response: JSONDictionary?
        feeds.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["rows"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        var index = 0
        for feedDictionary in array {
            if  let feedDictionary = feedDictionary as? JSONDictionary,
                let caption = feedDictionary["caption"] as? String,
                let urlString = feedDictionary["url"] as? String,
                let url = URL(string: urlString) {
                feeds.append(FeedItem(id: index, url: url, caption: caption))
                index += 1
            } else {
                errorMessage += "Problem parsing feedDictionary\n"
            }
        }
    }
}


