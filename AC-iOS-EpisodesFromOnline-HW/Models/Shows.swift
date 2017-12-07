//
//  Shows.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by C4Q on 12/4/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct AllInfo: Codable {
    let show: Shows
}

struct Shows: Codable {
    var id: Int?
    var name: String?
    
    //var premiered: String
    var rating: Rating?
    var image: Image?
}

struct Rating: Codable {
    var average: Double?
}

struct Image: Codable{
    var medium: String
    var original: String
}

struct Episode: Codable {
    var name: String?
    var season: Int?
    var number: Int?
    var image: Image?
    var summary: String?
}
