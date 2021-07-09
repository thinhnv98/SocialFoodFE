//
//  RestaurantDetailsView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 28/06/2021.
//

import SwiftUI
import Kingfisher

struct RestaurantDetails: Decodable {
    var rank: Int
    let city: String
    let country: String
    let description: String
    var popularDishes: [Dish]
    let photos: [String]
    let photoDetails: [PhotoDetails]
    var reviews: [Review]
}

struct PhotoDetails: Hashable, Decodable {
    var photo: String
    var description: String
    var createdAt: String
}

struct Review: Decodable, Hashable {
    let user: ReviewUser
    let rating: Int
    let text: String
}

struct ReviewUser: Decodable, Hashable {
    let id: Int
    let username, firstName, lastName, profileImage: String
}

struct Dish: Decodable, Hashable {
    var name, price, photo: String
    var numPhotos: Int
}

class RestaurantDetailsViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var details: RestaurantDetails?
    
    init(id: String) {
        //fetch json
        let urlString = "http://localhost:8080/api/restaurants-detail/\(id)"
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, resp, err in
            //handle
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.details = try? JSONDecoder().decode(RestaurantDetails.self, from: data)
            }
            
        }.resume()
    }
}

struct RestaurantDetailsView: View {
    
    let userID: Int
    @ObservedObject var vm: RestaurantDetailsViewModel
    
    let restaurant: Restaurant
    
    init(restaurant: Restaurant, userID: Int) {
        self.userID = userID
        self.restaurant = restaurant
        self.vm = .init(id: String(restaurant.id))
    }
    
    @State var isNewDish = false
    
    var body: some View {
        ScrollView() {
            ZStack (alignment: .bottomLeading){
                KFImage(URL(string: restaurant.imageName))
                    .resizable()
                    .frame(height: 250)
                    .scaledToFit()
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(restaurant.name)
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack {
                            if let rank = vm.details?.rank ?? 5 {
                                ForEach(0..<rank, id: \.self) { num in
                                    Image(systemName: "star.fill")
                                }.foregroundColor(.orange)
                                ForEach(0..<5 - rank, id: \.self) { num in
                                    Image(systemName: "star.fill")
                                }.foregroundColor(.gray)
                            } else {
                                ForEach(0..<5, id: \.self) { num in
                                    Image(systemName: "star.fill")
                                }.foregroundColor(.orange)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: RestaurantPhotosView(photoUrlStrings: vm.details?.photos ?? [], photoDetails: vm.details?.photoDetails ?? []),
                        label: {
                            Text("See more photos")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .regular))
                                .frame(width: 80)
                                .multilineTextAlignment(.trailing)
                        })
                }.padding()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Location & Description")
                    .font(.system(size: 16, weight: .bold))
                
                Text("\(vm.details?.city ?? ""), \(vm.details?.country ?? "")")
                
                HStack {
                    ForEach(0..<5, id: \.self) { num in
                        Image(systemName: "dollarsign.circle.fill")
                    }.foregroundColor(.orange)
                }
                HStack{
                    Spacer()
                }
            }
            .padding(.top)
            .padding(.horizontal)
            
            HStack {
                Text(vm.details?.description ?? "")
                    .padding(.top, 8)
                    .font(.system(size: 14, weight: .regular))
                    .padding(.horizontal)
                    .padding(.bottom)
                
                Spacer()
            }
            
            HStack{
                Text("Popular Dishes")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                NavigationLink (
                    destination: NewDish(restaurantID: restaurant.id, parentVm: vm),
                    label: {
                        Text("Create")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(5)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                            .background(Color.orange)
                            .cornerRadius(10)
                    })
            }.padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.details?.popularDishes ?? [], id: \.self) { dish in
                        Dishcell(dish: dish)
                    }
                }.padding(.horizontal)
            }
            
            if let reviews = vm.details?.reviews {
                ReviewsList(userID: self.userID, restaurant: restaurant, reviews: reviews, parentVm: vm)
            }
        }
        .navigationBarTitle("Restaurant Details", displayMode: .inline)
    }
}

struct ReviewsList: View {
    let userID: Int
    var restaurant: Restaurant
    let reviews: [Review]
    
    @ObservedObject var parentVm: RestaurantDetailsViewModel
    
    var body: some View {
        HStack{
            Text("Customer Reviews")
                .font(.system(size: 16, weight: .bold))
            Spacer()
            NavigationLink (
                destination: ReviewRestaurant(userID: self.userID, restaurant: restaurant, parentVm: parentVm),
                label: {
                    Text("Review")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(5)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                        .background(Color.orange)
                        .cornerRadius(10)
                })
        }.padding(.horizontal)
        
//        if let reviews = reviews {
            ForEach(reviews, id: \.self) { review in
                VStack(alignment: .leading) {
                    HStack {
                        KFImage(URL(string: review.user.profileImage))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(review.user.firstName) \(review.user.lastName)")
                                .font(.system(size: 14, weight: .bold))
                            
                            HStack(spacing: 4) {
                                ForEach(0..<review.rating, id: \.self) { num in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.orange)
                                }
                                
                                ForEach(0..<5 - review.rating, id: \.self) { num in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                            .font(.system(size: 12))
                        }
                        
                        Spacer()
                        Text("July 2021")
                            .font(.system(size: 14, weight: .bold))
                    }
                    
                    Text(review.text)
                        .font(.system(size: 14, weight: .regular))
                        
                }.padding(.top)
                .padding(.horizontal)
            }
//        }
    }
}

struct Dishcell: View {
    let dish: Dish
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                KFImage(URL(string: dish.photo))
                    .resizable()
                    .scaledToFill()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
                    .shadow(radius: 2)
                    .padding(.vertical, 2)
                
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .center, endPoint: .bottom)
                Image("")
                Text(dish.price)
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .regular))
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
            }
            .frame(height: 120)
            .cornerRadius(5)
            
            Text(dish.name)
                .font(.system(size: 14, weight: .bold))
            Text("\(dish.numPhotos) photos")
                .foregroundColor(.gray)
                .font(.system(size: 13, weight: .regular))
        }
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            HomeView()
//        }
//    }
//}
