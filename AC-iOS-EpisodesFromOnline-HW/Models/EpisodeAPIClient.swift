//
//  EpisodeAPIClient.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 12/6/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct EpisodeAPIClient {
    private init() {}
    static let manager = EpisodeAPIClient()
    
    func getEpisode(from str: String,
                  completionHandler: @escaping ([Episode]) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        
        let filter = str.replacingOccurrences(of: " ", with: "+")
        let urlStr = "http://api.tvmaze.com/shows/\(filter)/episodes"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let onlineEpisode = try JSONDecoder().decode([Episode].self, from: data)
                completionHandler(onlineEpisode)
            }
            catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
    
}
