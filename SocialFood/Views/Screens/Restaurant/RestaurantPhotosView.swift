//
//  RestaurantPhotosView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 30/06/2021.
//

import SwiftUI
import Kingfisher


struct RestaurantPhotosView: View {
    
    let photoUrlStrings: [String]
    let photoDetails: [PhotoDetails]
    
    @State var mode = "grid"
    
    init(photoUrlStrings: [String], photoDetails: [PhotoDetails]) {
        self.photoUrlStrings = photoUrlStrings
        self.photoDetails = photoDetails
        UISegmentedControl.appearance().backgroundColor = .black
        UISegmentedControl.appearance().selectedSegmentTintColor = .orange
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
    }
    
    @State var shouldShowFullScreenModal = false
    @State var selectedPhotoIndex = 0
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {

                Picker("Test", selection: $mode) {
                    Text("Grid").tag("grid")
                    Text("List").tag("list")
                }.pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldShowFullScreenModal, content: {
                        ZStack(alignment: .topLeading) {
                            Color.black.ignoresSafeArea()
                            
                            RestaurantCarouselContainer(imageUrlStrings: photoUrlStrings, selectedIndex: selectedPhotoIndex)
                            
                            Button(action: {
                                shouldShowFullScreenModal.toggle()
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding()
                            })
                        }
                    })
                    .opacity(shouldShowFullScreenModal ? 1 : 0)
                if mode == "grid" {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: proxy.size.width / 3 - 4, maximum: 600), spacing: 2)
                    ], spacing: 4, content: {
                        ForEach(photoUrlStrings, id: \.self) { urlString in
                            Button(action: {
                                self.selectedPhotoIndex = photoUrlStrings.firstIndex(of: urlString) ?? 0
                                shouldShowFullScreenModal.toggle()
                            }, label: {
                                KFImage(URL(string: urlString))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: proxy.size.width / 3 - 3, height: proxy.size.width / 3 - 3)
                                    .clipped()
                            })
                        }
                    }).padding(.horizontal, 2)
                } else {
                    ForEach(photoDetails, id: \.self) {photoDetail in
                        VStack(alignment: .leading, spacing: 8) {
                            KFImage(URL(string: photoDetail.photo))
                                .resizable()
                                .scaledToFill()
                            
                            HStack {
                                Image(systemName: "heart")
                                Image(systemName: "bubble.right")
                                Image(systemName: "paperplane")
                                Spacer()
                                Image(systemName: "bookmark")
                            }.padding(.horizontal, 8)
                            .font(.system(size: 22))
                            
//                            Text("Description for your post and it goes here, make sure to use a bunch of lines of text otherwise you never know what's going to happen. \n\nGreate job everyone")
                            Text("\(photoDetail.description)")
                                .font(.system(size: 14))
                                .padding(.horizontal, 8)
                            
                            Text("Posted on \(photoDetail.createdAt)")
                                .font(.system(size: 14))
                                .padding(.horizontal, 8)
                                .foregroundColor(.gray)
                            
                            
                        }.padding(.bottom)
                    }
                }
                
                
            }
        }
        .navigationBarTitle("All photos", displayMode: .inline)
    }
}
