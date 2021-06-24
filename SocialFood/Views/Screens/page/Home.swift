//
//  HomePlus.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 23/06/2021.
//

import Foundation
import SwiftUI

struct HomePlusView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    var body: some View{
        NavigationView{
            ZStack{
                //backgound color
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9989364743, green: 0.6389529705, blue: 0.1817156971, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4949038029, blue: 0.009055896662, alpha: 1))]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                
                
                Color(.init(white: 0.95, alpha: 1))
                    .offset(y: 400)
                
                ScrollView{
                    
                    HStack{
                        Image(systemName: "magnifyingglass")
                        Text("Where you want to go?")
                        Spacer()
                            
                    }.font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.init(white: 1, alpha: 0.3)))
                    .cornerRadius(10)
                    .padding(16)
                    
                    DiscoverCategoriesView()
                    
                    VStack{
                        
                        PopularDestinationsView()
                        
                        PopularRestaurantsView()
                        
                        TrendingCreatorsView()
                    }.background(Color(.init(white: 0.95, alpha: 1)))
                    .cornerRadius(16)
                    .padding(.top, 32)
                }
            }
            .navigationTitle("Social Travels")
        }
    }
}

struct Destination: Hashable {
    let name, country, imageName: String
}

struct PopularDestinationsView: View{
    
    let destinations: [Destination] = [
        .init(name: "Paris", country: "France", imageName: "1.paris"),
        .init(name: "Tokyo", country: "Japan", imageName: "1.tokyo"),
        .init(name: "New York", country: "US", imageName: "1.newyork"),
    ]
    
    var body: some View{
        VStack{
            HStack{
                Text("Popular destinations")
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing:8){
                    ForEach(destinations, id: \.self) { destination in
                        VStack(alignment: .leading, spacing: 0){
                            Image(destination.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 125, height: 123)
                                .cornerRadius(4)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 6)
                            
                            Text(destination.name)
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.horizontal, 12)
                            
                            Text(destination.country)
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.horizontal, 12)
                                .padding(.bottom, 8)
                                .foregroundColor(.gray)
                        }
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(color: .init(.sRGB, white: 0.8, opacity: 1), radius: 4, x: 0.0, y: 2)
                        .padding(.bottom)
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct Restaurant: Hashable {
    let name, imageName: String
}

struct PopularRestaurantsView: View{
    
    let restaurants: [Restaurant] = [
        .init(name: "Japan's Finest Tapas", imageName: "1.tapas"),
        .init(name: "Bar & Grill", imageName: "1.bargrill"),
    ]
    
    var body: some View{
        VStack{
            HStack{
                Text("Popular places to eat")
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing:8){
                    ForEach(restaurants, id: \.self) {restaurant in
                        HStack(spacing: 8){
                            Image(restaurant.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(5)
                                .padding(.leading, 6)
                                .padding(.vertical, 6)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                HStack{    
                                    Text(restaurant.name)
                                    Spacer()
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.gray)
                                    })
                                }
                                
                                HStack{
                                    Image(systemName: "star.fill")
                                    Text("4.7 • Sushi • $$")
                                }
                                
                                Text("Tokyo, Japan")
                                    
                            }
                            .font(.system(size: 12, weight: .semibold))
                            
                            Spacer()
                        }
                        .frame(width: 240)
                        .background(Color.white)
                        .cornerRadius(5)
                        .shadow(color: .init(.sRGB, white: 0.8, opacity: 1), radius: 4, x: 0.0, y: 2)
                        .padding(.bottom)
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct Creator: Hashable {
    let name, imageName: String
}

struct TrendingCreatorsView: View{
    
    let creators: [Creator] = [
        .init(name: "Amy Adams", imageName: "1.amyadams"),
        .init(name: "Billy Childs", imageName: "1.billychilds"),
        .init(name: "Sam Smith", imageName: "1.samsmith"),
    ]
    
    var body: some View{
        VStack{
            HStack{
                Text("Trending creators")
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                
                HStack(alignment: .top, spacing: 12){
                    ForEach(creators, id: \.self){creator in
                        VStack{
                            Image(creator.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .cornerRadius(60)
                            Text(creator.name)
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .frame(width: 60)
                        .shadow(color: .gray, radius: 4, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2)
                        .padding(.bottom)
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct Category: Hashable {
    let name, imageName: String
}

struct DiscoverCategoriesView: View {
    
    let categories: [Category] = [
        .init(name: "Art", imageName: "paintpalette.fill"),
        .init(name: "Sport", imageName: "sportscourt.fill"),
        .init(name: "Live Events", imageName: "music.mic"),
        .init(name: "Food", imageName: "tray.fill"),
        .init(name: "History", imageName: "books.vertical.fill"),
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 14){
                ForEach(categories, id: \.self ) { category in
                    VStack(spacing: 8){
                        
                        Image(systemName: category.imageName)
                            .font(.system(size: 20))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.6390548348, blue: 0, alpha: 1)))
                            .frame(width: 64, height: 64)
                            .background(Color.white)
                            .cornerRadius(64)
                        Text(category.name)
                            .font(.system(size: 12, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        
                    }.frame(width: 68)
                }
                
            }
            .padding(.horizontal)
        }
    }
}
