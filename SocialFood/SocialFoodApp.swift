//
//  SocialFoodApp.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 18/06/2021.
//

import SwiftUI

@main
struct SocialFoodApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                AppInstance: AppInstance(
                    user: User(
                        Email: "",
                        Password: "",
                        AccountType: ""
                    ),
                    userService: UserService()
                )
            )
        }
    }
}
