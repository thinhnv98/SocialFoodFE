//
//  Restaurant.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 04/07/2021.
//

import Foundation

struct RestaurantCreateRequest {
    var id: Int
    var name, imageName, imageData, city, country, description: String
}

struct RestaurantReviewResponse: Decodable {
    var isSuccess: Bool
    var rank: Double
    var reviews: [Review]
}
