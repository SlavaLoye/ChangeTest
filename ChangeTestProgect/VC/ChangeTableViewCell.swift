//
//  ChangeTableViewCell.swift
//  ChangeTestProgect
//
//  Created by Вячеслав Лойе on 08.03.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit

class ChangeTableViewCell: UITableViewCell {
    
    static let cellId = "Cell"
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    override func prepareForReuse() {
        amountLabel.text?.removeAll()
        nameLabel.text?.removeAll()
        volumeLabel.text?.removeAll()
        
    }

    // MARK: configureCell (func)
    func configureCell(_ change: JsonChange ) {
        _ = NewsDataService.instance.newsChanges
        nameLabel.text = change.name
        let formatterAmount = NumberFormatter()
        formatterAmount.numberStyle = .decimal
        amountLabel.text = "\(formatterAmount.string(from: NSNumber(value: change.amount!))!) bil"
        let formatterVolume = NumberFormatter()
        formatterVolume.numberStyle = .decimal
        volumeLabel.text = "\(formatterVolume.string(from: NSNumber(value: change.volume!))!) Volume"
    }
}

