//
//  ContentView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 18/06/2021.
//

import SwiftUI

struct ContentView: View {
    @State var AppInstance: AppInstance
    var body: some View {
        LoginView(user: self.AppInstance.User, userService: self.AppInstance.UserService)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(AppInstance: AppInstance(
                user: User(Email: "", NickName: "", FirstName: "", LastName: "", ImageProfile: "", Password: "", AccountType: ""),
                userService: UserService()
            )
        )
    }
}
