//
//  NewDish.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 04/07/2021.
//

import SwiftUI

struct NewDish: View {
    let restaurantID: Int
    let restaurantService = RestaurantService()
    
    @ObservedObject var parentVm: RestaurantDetailsViewModel
    
    @State var dishState = Dish(name: "", price: "", photo: "", numPhotos: 0)
    @State var numPhotoString = ""
    @State var imageThumbnail = UIImage()
    @State var isShowingImagePicker = false
    @State var isCreating = false
    @State var createNotificationTitle = "Creating"
    @State var createNotificationDescription = "Waiting for response..."
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Infomation")){
                    TextField("Name", text: $dishState.name)
                    TextField("Price", text: $dishState.price)
                    TextField("Number of photos", text: $numPhotoString)
                }
                Section(header: Text("Image thumbnail")){
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
            }
            
            Spacer()
                .alert(isPresented: $isCreating) {
                    Alert(title: Text(self.createNotificationTitle),
                          message: Text(self.createNotificationDescription),
                          dismissButton: .default(Text("OK")))
                }
            
            VStack{
                Button(action: {
                    self.isCreating = true
                    self.dishState.photo = imageToBase64(image: self.imageThumbnail)
                    self.dishState.numPhotos = Int(self.numPhotoString)!
                    
                    self.restaurantService.CreateNewDish(restaurantID: restaurantID, dish: dishState) { StatusResponse in
                        if StatusResponse.isSuccess {
                            self.restaurantService.GetDishes(restaurantID: restaurantID) { result in
                                self.parentVm.details?.popularDishes = result.result
                            }
                            self.createNotificationTitle = "Succeed"
                            self.createNotificationDescription = "OK"
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
        .navigationBarTitle("New Dish", displayMode: .inline)
    }
}
//
//struct Dish_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            HomeView()
//        }
//    }
//}
