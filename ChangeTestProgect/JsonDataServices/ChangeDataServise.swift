//
//  ChangeDataServise.swift
//  ChangeTestProgect
//
//  Created by Вячеслав Лойе on 09.03.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import Foundation
import Alamofire

typealias DownloadComplete = () -> ()

class NewsDataService {
    static let instance = NewsDataService()
    var newsChanges = [JsonChange]()
    func parsNews(completed: @escaping DownloadComplete)  {
        var nameString: String!
        var amountCount: Double!
        var volumeCount: Int!

        let url = CHANGE_URL
        request(url).responseJSON { (response) in
            print(response)
            if let JSON = response.result.value as? [String: Any] {
                if let changeArray = JSON["stock"] as? [Dictionary<String, Any>], changeArray.count > 0  {
                    for i in 0..<changeArray.count {
                        if let name = changeArray[i]["name"] as? String {
                            nameString = name
                        }
                        if let priceCount = changeArray[i]["price"] as? [String: Any] {
                            if let amount = priceCount["amount"] as? Double {
                                amountCount = amount
                            }
                            if let volume = changeArray[i]["volume"] as? Int {
                                volumeCount = volume
                            }

                            //MARK: NewChange
                            let newChange = JsonChange(name: nameString, volume: volumeCount, amount: amountCount)
                            self.newsChanges.append(newChange)
                        }
                    }
                }
                completed()
            }
        }
    }
}

