//
//  Register.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 21/06/2021.
//

import Foundation
import SwiftUI

struct RegisterState {
    var email: String
    var password: String
    var passwordConfirm: String
    var colorState: Bool
    var typeSelected: String
    var isCreated: Bool
    var isExisted: Bool
}

struct RegisterView: View {
    @Binding var state: RegisterState
    @Binding var userService: UserService
    @Binding var isGoBack: Bool
    
    var body: some View{
        VStack(spacing: 15){
            Form {
                Section(header: Text("Information")) {
                    TextField("Email", text: $state.email)
                        .frame(height: 50)
                        .alert(isPresented: $state.isCreated) {
                            Alert(title: Text("Success!"),
                                  message: Text("Go back to login page"),
                                  dismissButton: .default(Text("OK"), action: {
                                    isGoBack = false
                                  }))
                        }
                    TextField("Password", text: $state.password)
                        .frame(height: 50)
                    TextField("Password Confirm", text: $state.passwordConfirm)
                        .frame(height: 50)
                }
                ConfigAccountView(state: $state)
                    .alert(isPresented: $state.isExisted) {
                        Alert(title: Text("Failed!"),
                              message: Text("Email address existed"),
                              dismissButton: .default(Text("OK")))
                    }
            }
            .navigationBarTitle("Register")
            Spacer()
                
            Button(action: {
                self.userService.Register(user: User(Email: state.email, Password: state.password, AccountType: state.typeSelected)) { registerResponse in
                    if registerResponse.IsExisted {
                        state.isExisted = true
                        state.isCreated = false
                    }
                    
                    if registerResponse.IsSuccess {
                        state.isExisted = false
                        state.isCreated = true
                    }
                }
            }, label: {
                ConfirmText()
            })
        }
    }
}

struct CheckMarkValid: View {
    @Binding var colorState: Bool
    var body: some View {
        Image(systemName: "checkmark.circle")
            .font(Font.title.weight(.thin))
            .foregroundColor(.green)
            .opacity(colorState ? 1 : 0)
    }
}

struct ConfirmText: View {
    var body: some View {
        Text("Confirm")
            .bold()
            .frame(width: 150, height: 50, alignment: .center)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct ConfigAccountView: View {
    @Binding var state: RegisterState
    var typeColor: Color {
        switch state.colorState {
            case false:
                return .red
            default:
                return .green
        }
    }
    var body: some View {
        Section(header: Text("Configuration")) {
            HStack{
                Text(state.typeSelected).contextMenu()
                {
                    Button(action: {
                        self.state.typeSelected = "CUSTOMER"
                        self.state.colorState = true
                    }, label: {
                        Text("Customer")
                        Image(systemName: "person.2")
                            .foregroundColor(.green)
                    })
                    Button(action: {
                        self.state.typeSelected = "VENDOR"
                        self.state.colorState = true
                    }, label: {
                        Text("Vendor")
                        Image(systemName: "person.circle")
                            .foregroundColor(.red)
                    })
                }
                .frame(height: 50)
                .foregroundColor(typeColor)
                Spacer()
                CheckMarkValid(colorState: $state.colorState)
            }
        }
    }
}
