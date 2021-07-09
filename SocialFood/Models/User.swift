//
//  user.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 18/06/2021.
//

import Foundation

struct User {
    let ID = UUID()
    var Email: String
    var NickName: String
    var FirstName: String
    var LastName: String
    var ImageProfile: String
    var Password: String
    var AccountType: String
}

struct StatusResponse: Decodable {
    var isSuccess: Bool
}
