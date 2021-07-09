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
    var nickName: String
    var firstName: String
    var lastName: String
    var imageProfile: String
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
    @State var imageProfile = UIImage()
    @State var isShowingImagePicker = false
    @State var isDifferentPassword = false
    @State var isInvalidData = false
    
    var body: some View{
        VStack(spacing: 15){
            Form {
                Section(header: Text("Information")) {
                    TextField("Email", text: $state.email)
                        .frame(height: 50)
                    TextField("Nick name",text: $state.nickName)
                    TextField("First name",text: $state.firstName)
                    TextField("Last name",text: $state.lastName)
                    SecureField("Password", text: $state.password)
                        .frame(height: 50)
                    SecureField("Password Confirm", text: $state.passwordConfirm)
                        .frame(height: 50)
                }.alert(isPresented: $isDifferentPassword) {
                    Alert(title: Text("Error!"),
                          message: Text("Password mismatch, verify again!"),
                          dismissButton: .destructive(Text("OK")))
                }
                
                
                Section(header: Text("Profile Image")) {
                    VStack {
                        Image(uiImage: imageProfile)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 60)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                            .clipped()
                        
                        Button(action: {
                            self.isShowingImagePicker.toggle()
                        }, label: {
                            Text("Select image")
                                .font(.system(size: 12))
                        })
                        .sheet(isPresented: $isShowingImagePicker, content: {
                            ImagePickerView(isPresented: $isShowingImagePicker, selectedImage: self.$imageProfile)
                        })
                    }
                }
                .alert(isPresented: $state.isCreated) {
                    Alert(title: Text("Success!"),
                          message: Text("Go back to login page"),
                          dismissButton: .default(Text("OK"), action: {
                            isGoBack = false
                          }))
                }
                
                ConfigAccountView(state: $state)
                    .alert(isPresented: $state.isExisted) {
                        Alert(title: Text("Failed!"),
                              message: Text("Email address existed"),
                              dismissButton: .default(Text("OK")))
                    }
            }
            .navigationBarTitle("Register", displayMode: .inline)
            Spacer()
                .alert(isPresented: $isInvalidData) {
                    Alert(title: Text("Error!"),
                          message: Text("Please fill full information"),
                          dismissButton: .destructive(Text("Cancel")))
                }
                
            Button(action: {
                if state.email == "" || state.nickName == "" || state.firstName == "" || state.lastName == "" || state.password == "" || state.passwordConfirm == "" {
                    self.isInvalidData = true
                    return
                }
                self.state.imageProfile = imageToBase64(image: self.imageProfile)
                
                if state.password != state.passwordConfirm {
                    self.isDifferentPassword = true
                    return
                }
                
                self.userService.Register(user: User(Email: state.email, NickName: state.nickName, FirstName: state.firstName, LastName: state.lastName, ImageProfile: state.imageProfile, Password: state.password, AccountType: state.typeSelected)) { registerResponse in
                    if registerResponse.IsExisted {
                        state.isExisted = true
                    }
                    
                    if registerResponse.IsSuccess {
                        self.state.isCreated = true
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
