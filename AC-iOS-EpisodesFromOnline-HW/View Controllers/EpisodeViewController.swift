//
//  EpisodeViewController.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 12/6/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController,UITableViewDataSource {
    var episodes = [Episode](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var show: Shows!{
        didSet{
            loadData()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
    }
    func loadData(){
        if let showID = show.id{
            let str = "\(showID)"
            let completionEpisodes:([Episode]) -> Void = {(onlinEpisodes: [Episode]) in
                self.episodes = onlinEpisodes
            }
            let error = {print($0)}
            EpisodeAPIClient.manager.getEpisode(from: str, completionHandler: completionEpisodes, errorHandler: error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Episode Cell", for: indexPath)
        let singleEpisode = episodes[indexPath.row]
        cell.textLabel?.text = singleEpisode.name ?? ""
        cell.detailTextLabel?.text = "S:\(singleEpisode.season ?? 0) E:\(singleEpisode.number ?? 0)"
        if let str = singleEpisode.image {
            let completion:(UIImage) -> Void = {(onlineImage: UIImage) in
                cell.imageView?.image = onlineImage
                cell.setNeedsLayout()
            }
            ImageAPIClient.manager.getImage(from: str.medium, completionHandler: completion, errorHandler: {print($0)})
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "noImage")
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailedEVC = segue.destination as? EpisodeDetailViewController {
            detailedEVC.episode = episodes[self.tableView.indexPathForSelectedRow!.row]
        }
    }
}
