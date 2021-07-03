//
//  Destination.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import Foundation

struct Destination: Hashable, Decodable {
    let id: Int
    var name, country, imageName, imageData, description: String
    var latitude, longitude: Double
}


struct DestinationDetail: Decodable {
    var vote: Int
    let description: String
    let photos: [String]
}

struct DestinationVote: Hashable, Decodable {
    var vote: Int
    var destinationID: Int
}

struct RankResponse: Hashable, Decodable {
    var isSuccess: Bool
    var rank: Int
}
