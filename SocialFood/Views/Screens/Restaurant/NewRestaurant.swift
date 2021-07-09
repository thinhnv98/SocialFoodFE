//
//  NewRestaurant.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 04/07/2021.
//

import Foundation
import SwiftUI

struct NewRestaurantState {
    var name: String
    var city: String
    var country: String
    var description: String
    var imageData: String
}

struct NewRestaurant: View {
    let restaurantService = RestaurantService()
    @ObservedObject var parentVm: RestaurantViewModel
    
    @State var newRestaurantState = NewRestaurantState(name: "", city: "", country: "",
                                                       description: "", imageData: "")
    @State var imageThumbnail = UIImage()
    @State var isShowingImagePicker = false
    
    @State var isCreating = false
    @State var createNotificationTitle = "Creating"
    @State var createNotificationDescription = "Waiting for response..."
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Infomation")) {
                    TextField("name", text: $newRestaurantState.name)
                    TextField("city", text: $newRestaurantState.city)
                    TextField("country", text: $newRestaurantState.country)
                    TextField("Description", text: $newRestaurantState.description)
                }
                .alert(isPresented: $isCreating) {
                    Alert(title: Text(self.createNotificationTitle),
                          message: Text(self.createNotificationDescription),
                          dismissButton: .default(Text("OK")))
                }
                
                Section(header: Text("Image thumbnail")) {
                    VStack {
                        Image(uiImage: imageThumbnail)
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
                            ImagePickerView(isPresented: $isShowingImagePicker, selectedImage: self.$imageThumbnail)
                        })
                    }
                }
            }.navigationBarTitle("New Restaurant", displayMode: .inline)
            Spacer()
            Button(action: {
                self.isCreating = true
                self.newRestaurantState.imageData = imageToBase64(image: self.imageThumbnail)
                self.restaurantService.CreateNewRestaurant(restaurant: RestaurantCreateRequest(id: 0, name: newRestaurantState.name, imageName: newRestaurantState.imageData, imageData: newRestaurantState.imageData, city: newRestaurantState.city, country: newRestaurantState.country, description: newRestaurantState.description)) { StatusResponse in
                    if StatusResponse.isSuccess {
                        self.createNotificationTitle = "Succeed"
                        self.createNotificationDescription = "OK"
                        self.restaurantService.GetRestaurant { result in
                            self.parentVm.restaurants = result.result
                        }
                    } else {
                        self.createNotificationTitle = "Failed"
                        self.createNotificationDescription = "Cancel"
                    }
                }
            }, label: {
                Text("Create")
                    .bold()
                    .frame(width: 150, height: 50, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
        }
    }
}
