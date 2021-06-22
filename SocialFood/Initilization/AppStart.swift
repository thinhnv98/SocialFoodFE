//
//  AppStart.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 21/06/2021.
//

import Foundation

class AppInstance {
    var User: User!
    var UserService: UserService!
    
    init(user: User, userService: UserService){
        self.User = user
        self.UserService = userService
    }
}
