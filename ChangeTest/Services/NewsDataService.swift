//
//  NewsDataService.swift
//  ChangeTest
//
//  Created by Вячеслав Лойе on 06.03.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import Foundation
import Alamofire

//[Dictionary<String, Any>]

typealias DownloadComplete = () -> ()

class NewsDataService {
    static let instance = NewsDataService()
    var newsChange = [JsonChange]()
    func parsNews(completed: @escaping DownloadComplete)  {
        var nameString: String!
        let url = CHANGE_URL
        request(url!).responseJSON { (response) in
            print(response)
            if let JSON = response.result.value as? [String: Any] {
                if let changeArray = JSON["stock"] as? [Dictionary<String, Any>], changeArray.count > 0  {
                    for i in 0..<changeArray.count {
                        if let name = changeArray[i]["name"] as? String {
                            nameString = name
                        }
                        if let priceCount = changeArray[i]["price"] as? [String: Any] {
                            let currency = priceCount["currency"] as! String
                            let amount = priceCount["amount"] as! Double
                            let percent_change = changeArray[i] ["percent_change"] as? Double
                            let volume = changeArray[i]["volume"] as! Int

                            //MARK: News
                            let newChange = JsonChange(name: nameString, percent_change: percent_change, volume: volume, currency: currency, amount: amount)
                            self.newsChange.append(newChange)
                        }
                    }
                }
                completed()
            }
        }
    }
}

