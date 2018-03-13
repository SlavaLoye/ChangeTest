//
//  ViewController.swift
//  ChangeTestProgect
//
//  Created by Вячеслав Лойе on 08.03.2018.
//  Copyright © 2018 Вячеслав Лойе. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating  {

    // MARK: Outlets
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    // MARK: Properties
    fileprivate var searchController: UISearchController!
    fileprivate var refreshControl: UIRefreshControl!
    fileprivate  var imageView = UIImageView()
    fileprivate static let indentifier = "NewsViewController"
    fileprivate let cellIdentifier = "Cell"
    fileprivate var newsChange = [JsonChange]()
    fileprivate var searchResult = [JsonChange]()
    fileprivate var timer: Timer?
    fileprivate var initialConstrats = [NSLayoutConstraint]()

    // MARK: Overriden funcs viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        refreshControll()
        spinerAction()
        reloadByTimer()
        searchBarItem()
    }

    // MARK:  @objc func updateTime()
    @objc func reloadByTimer() {
        timer =  Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(reloadData), userInfo: nil, repeats: true)
        reloadData()
    }

    // MARK:  @objc func reloadData()
    @objc func reloadData() {
        NewsDataService.instance.parsNews {
            self.newsChange = NewsDataService.instance.newsChanges
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            print("Reload Data")
        }
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
//
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResult.count
        } else {
            return newsChange.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChangeTableViewCell {
            let changeUptade = (searchController.isActive) ? searchResult[indexPath.row] : newsChange[indexPath.row]
            cell.configureCell(changeUptade)
            cell.backgroundColor = #colorLiteral(red: 0.8675079942, green: 0.6783022285, blue: 0.2592797577, alpha: 1)
            cell.layer.borderColor  = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
            cell.layer.borderWidth = 2
            cell.layer.cornerRadius = 8
            cell.clipsToBounds = true
            return cell
        } else {
            return ChangeTableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 1. set the initial state of the cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        // 2. UIView animation method to change to The final state of the cell
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        } else {
            return true
        }
    }

    // MARK: SearchBar (fileprivate func)
    fileprivate func searchBarItem() {
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        searchController.searchBar.tintColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        tableView.tableHeaderView!.backgroundColor = #colorLiteral(red: 0.8675079942, green: 0.6783022285, blue: 0.2592797577, alpha: 1)
        searchController.searchBar.backgroundColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for tools and resources"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
    }

    //MARK: - UpdateSearch (func)
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(searchText: searchText)
            tableView.reloadData()
        }
    }

    //MARK: - FilterContent (fileprivate func)
    fileprivate func filterContent(searchText: String) {
        searchResult = newsChange.filter({(newsType: JsonChange) -> Bool in
            let nameMatch = newsType.name?.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            return nameMatch != nil
        })
    }

    // MARK: fileprivate func refreshControll()
    fileprivate func refreshControll() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        refreshControl.backgroundColor = #colorLiteral(red: 0.2587913573, green: 0.2588421106, blue: 0.2587881684, alpha: 1)
        refreshControl.tintColor = #colorLiteral(red: 0.8675079942, green: 0.6783022285, blue: 0.2592797577, alpha: 1)
        reloadData()
    }

    // MARK: fileprivate func spinerAction()
    fileprivate func spinerAction()  {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let spinnerImage = UIImage(named: "crypto_icons_98-512")
        imageView.contentMode = .scaleAspectFill
        imageView.image = spinnerImage
        refreshControl.addSubview(imageView)
        let widtConstrain = imageView.widthAnchor.constraint(equalToConstant: 100)
        let heightConstrain = imageView.heightAnchor.constraint(equalToConstant: 100)
        let centerXConstrain = imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let topAnchorConstrain = imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80)
        NSLayoutConstraint.activate([widtConstrain,heightConstrain,centerXConstrain, topAnchorConstrain])
    }

    // MARK: @IBAction()
    @IBAction func updateChangeButtonAction(_ sender: UIButton) {
        let buttonChange = newsChange
        reloadData()
        blueButton.isHidden = buttonChange.count == newsChange.count ? true : false
        print("Update")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

    }
}
