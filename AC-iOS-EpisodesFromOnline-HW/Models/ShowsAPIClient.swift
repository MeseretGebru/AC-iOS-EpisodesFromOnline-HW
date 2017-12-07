//
//  ShowsAPIClient.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 12/6/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

struct ShowsAPIClient {
    private init() {}
    static let manager = ShowsAPIClient()
    
    func getShows(from str: String,
                   completionHandler: @escaping ([AllInfo]) -> Void,
                   errorHandler: @escaping (Error) -> Void) {
        
        let filter = str.replacingOccurrences(of: " ", with: "+")
        let urlStr = "http://api.tvmaze.com/search/shows?q=\(filter)"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let onlineShows = try JSONDecoder().decode([AllInfo].self, from: data)
                completionHandler(onlineShows)
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







