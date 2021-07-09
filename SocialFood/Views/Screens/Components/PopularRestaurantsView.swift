//
//  PopularRestaurantsView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import SwiftUI
import Kingfisher
import SDWebImage
import SDWebImageSwiftUI


struct Restaurant: Hashable, Decodable {
    let id: Int
    let name, imageName: String
}

struct PopularRestaurantsView: View{
    
    let userID: Int
    @ObservedObject var vm = RestaurantViewModel()
    
    let restaurants: [Restaurant] = [
        .init(id: 1, name: "Japan's Finest Tapas", imageName: "1.tapas"),
        .init(id: 2, name: "Bar & Grill", imageName: "1.bargrill"),
    ]
    
    var body: some View{
        VStack{
            HStack{
                Text("Popular places to eat")
                    .font(.system(size: 12, weight: .semibold))
                Spacer()
                NavigationLink (
                    destination: NewRestaurant(parentVm: vm),
                    label: {
                        Text("Create")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(.label))
                    })
                
            }.padding(.horizontal)
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack(spacing: 8.0) {
                    ForEach(vm.restaurants ?? [], id: \.self) { restaurant in
                        NavigationLink(
                            destination: RestaurantDetailsView(restaurant: restaurant, userID: self.userID),
                            label: {
                                RestaurantTile(restaurant: restaurant)
                                    .foregroundColor(Color(.label))
                            })
                    }
                }.padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

struct RestaurantTile: View {
    
    @ObservedObject var vm: RestaurantDetailsViewModel
    let restaurant: Restaurant
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        self.vm = .init(id: String(restaurant.id))
    }
    
    var body: some View {
        HStack(spacing: 8){
//            Image(restaurant.imageName)
            //                                                                WebImage(url: URL(string: imageName))
            //                                                                    .resizable()
            //                                                                    .indicator(.activity) // Activity Indicator
            //                                                                        .transition(.fade(duration: 0.5)) // Fade Transition with duration
            //                                                                    .scaledToFit()
            
//            KFImage(URL(string: restaurant.imageName))
            WebImage(url: URL(string: restaurant.imageName))
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
                    Text("Food • Beautiful • $$")
                }
                
                Text("\(vm.details?.city ?? ""), \(vm.details?.country ?? "")")
                    
            }
            .font(.system(size: 12, weight: .semibold))
            
            Spacer()
        }
        .frame(width: 240)
        .asTile()
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            HomeView()
//        }
//    }
//}
