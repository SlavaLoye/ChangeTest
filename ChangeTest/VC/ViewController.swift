//
//  ViewController.swift
//  ChangeTest
//
//  Created by Вячеслав Лойе on 06.03.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit
//import Alamofire
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var imageView: UIImageView!
    private static let indentifier = "NewsViewController"
    private let cellIdentifier = "Cell"
    private var newsChange = [JsonChange]()
    var allTime = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
    }

    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsChange.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChangeTableViewCell
        cell.nameLabel?.text = newsChange[indexPath.row].name
        return cell
    }

    // MARK:  @objc func reloadData()
    @objc func reloadData() {
        NewsDataService.instance.parsNews {
            self.newsChange = NewsDataService.instance.newsChange
            self.tableView.reloadData()
        }
    }

}
