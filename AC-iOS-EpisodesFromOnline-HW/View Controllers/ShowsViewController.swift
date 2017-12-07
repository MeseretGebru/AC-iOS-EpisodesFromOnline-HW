//
//  ShowsViewController.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 12/6/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var allShows = [AllInfo](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var searchTerm = "" {
        didSet {
            loadShowsData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }
    
    func loadShowsData(){
        let setShows: ([AllInfo]) -> Void = {(onlineShows: [AllInfo]) in
            self.allShows = onlineShows
        }
        
        ShowsAPIClient.manager.getShows(from: searchTerm, completionHandler: setShows, errorHandler: {print($0)})
    }
    
}

extension ShowsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allShows.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "Shows Cell", for: indexPath) as? ShowTableViewCell{
            let show = allShows[indexPath.row]
            cell.nameLabel.text = show.show.name ?? "No name"
            if let rating = show.show.rating{
                cell.ratingLabel.text = "\(rating.average ?? 0.0)"
            } else {
                cell.ratingLabel.text = "No rating"
            }
            cell.showImageView.image = nil
            cell.spiner.isHidden = true
            cell.spiner.startAnimating()
            if let image = show.show.image {
                let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
                    cell.showImageView.image = onlineImage
                    cell.setNeedsLayout()
                    cell.spiner.stopAnimating()
                    cell.spiner.isHidden = true
                }
                ImageAPIClient.manager.getImage(from: image.medium,
                                                completionHandler: completion,
                                                errorHandler: {print($0)})
            } else {
                cell.showImageView.image = #imageLiteral(resourceName: "noImage")
                cell.spiner.stopAnimating()
                cell.spiner.isHidden = true
            }
            return cell
            
        }
        return UITableViewCell()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationDVC = segue.destination as? EpisodeViewController{
            destinationDVC.show = allShows[self.tableView.indexPathForSelectedRow!.row].show
        }
    }
}


extension ShowsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //self.searchTerm = self.searchBar.text ?? "" // same as below
        guard let searchWord = self.searchBar.text else {return}
        self.searchTerm = searchWord
    }
}

