//
//  EpisodeDetailViewController.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 12/6/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController{
    
    var episode: Episode!
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeSeasonLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()

        // Do any additional setup after loading the view.
    }
    func setLabels(){
        episodeNameLabel.text = episode.name ?? ""
        episodeSeasonLabel.text = "S: \(episode.season ?? 0) E: \(episode.number ?? 0)"
        descriptionTextView.text = episode.summary ?? ""
        
        if let urlImage = episode.image{
            let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            self.episodeImageView.image = onlineImage
            }
            ImageAPIClient.manager.getImage(from: urlImage.original, completionHandler: completion, errorHandler: {print($0)})
        }
    }

}
