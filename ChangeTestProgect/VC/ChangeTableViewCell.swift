//
//  ChangeTableViewCell.swift
//  ChangeTestProgect
//
//  Created by Вячеслав Лойе on 08.03.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit

class ChangeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    // MARK: configureCell (func)
    func configureCell( _ change: JsonChange ) {
        _ = NewsDataService.instance.newsChanges
        nameLabel.text = change.name
        let formatterAmount = NumberFormatter()
        formatterAmount.numberStyle = .decimal
        amountLabel.text = "\(formatterAmount.string(from: NSNumber(value: change.amount!))!) Amount"
        let formatterVolume = NumberFormatter()
        formatterVolume.numberStyle = .decimal
        volumeLabel.text = "\(formatterVolume.string(from: NSNumber(value: change.volume!))!) Volume"
        
    }
}


