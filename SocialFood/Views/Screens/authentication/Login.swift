//
//  Login.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 18/06/2021.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State var user: User
    @State var userService: UserService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15){
                Spacer()
                Spacer()
                LoginPageTitle()
                LoginPageImageCircle()
                UserNameView(email: $user.Email)
                PasswordView(password: $user.Password)
                ForgotPassword()
                LoginButtonView(userService: $userService, user: $user)
                Register(userService: $userService)
                Spacer()
            }.background(
                Image("ImgLoginBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            ).edgesIgnoringSafeArea(.all)
        }
    }
}

struct UserNameView: View {
    @Binding var email: String
    var body: some View {
        HStack{
            Image(systemName: "envelope")
                .foregroundColor(.gray)
                .padding()
            TextField("Email", text: $email)
        }.frame(height: 60)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 20)
    }
}

struct PasswordView: View {
    @Binding var password: String
    var body: some View {
        HStack{
            Image(systemName: "lock")
                .foregroundColor(.gray)
                .padding()
            SecureField("Password", text: $password)
        }.frame(height: 60)
        .background(Color.white)
        .cornerRadius(8)
        .padding(.horizontal, 20)
    }
}

struct LoginButtonView: View {
    @Binding var userService: UserService
    @Binding var user: User
    @State var isShowErr = false
    @State var isFailed = false
    @State var isLoginSuccess = false
    
    var body: some View {
        Text("").hidden()
            .alert(isPresented: $isFailed) {
                Alert(title: Text("Failed!").foregroundColor(.red),
                      message: Text("Email & Password invalid!"),
                      dismissButton: .destructive(Text("Cancel")))
            }
        Button(action: {
            self.isLoginSuccess = true
//            if self.user.Email == "" || self.user.Password == "" {
//                self.isShowErr = true
//                return
//            }
//
//            self.userService.Authenticate(user: user) { isSuccess in
//                self.isLoginSuccess = isSuccess
//                self.isFailed = !isSuccess
//            }
            return
        }, label: {
            Text("Login")
                .bold()
                .frame(width: 150, height: 50, alignment: .center)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        })
        ZStack{
            Text("").hidden()
                .fullScreenCover(isPresented: $isLoginSuccess, content: {
                    HomePlusView()
                })
        }
        .alert(isPresented: $isShowErr) {
            Alert(title: Text("Error!").foregroundColor(.red),
                  message: Text("Email & Password is required!"),
                  dismissButton: .default(Text("OK")))
            }
    }
}

struct LoginPageTitle: View {
    var body: some View {
        Text("Social Travels")
            .font(.system(size: 64, weight: .semibold))
            .foregroundColor(.white)
    }
}

struct LoginPageImageCircle: View {
    var body: some View {
        Image("ImageFoodCircle")
            .resizable()
            .frame(width: 200, height: 200)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.green))
            .shadow(radius: 10)
    }
}

struct ForgotPassword: View {
    var body: some View {
        NavigationLink(
            destination: ForgotPasswordView(),
            label: {
                HStack{
                    Spacer()
                    Text("FORGOT PASSWORD?")
                        .bold()
                        .foregroundColor(.red)
                        .shadow(radius: 10)
                }.padding(.horizontal, 20)
            })
    }
}

struct Register: View {
    @State var registerState = RegisterState(email: "", password: "", passwordConfirm: "", colorState: false, typeSelected: "CHOOSE ACCOUNT'S TYPE!", isCreated: false, isExisted: false)
    @State var isGoBack = false
    @Binding var userService: UserService
    var body: some View {
        NavigationLink(
            destination: RegisterView(state: $registerState, userService: $userService, isGoBack: $isGoBack),
            isActive: $isGoBack,
            label: {
                Text("Create an account?")
                    .bold()
                    .foregroundColor(.green)
            })
    }
}
