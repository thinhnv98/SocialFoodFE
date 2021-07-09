//
//  ReviewRestaurant.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 04/07/2021.
//

import SwiftUI

struct ReviewRestaurantRequest: Decodable {
    var userID: Int
    var restaurantID: Int
    var rank: Int
    var text: String
}

struct ReviewRestaurant: View {
    let userID: Int
    var restaurant: Restaurant
    
    let restaurantService = RestaurantService()
    
    @ObservedObject var parentVm: RestaurantDetailsViewModel
    
    @State var text = ""
    @State var starVoted = "..."
    @State var starVotedInt = 0
    @State var isReviewed = false
    @State var newRank: Double = 0.0
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Review feedback")
                    .font(.system(size: 18, weight: .semibold))
                Spacer()
            }
            TextField("Please fill some comment...", text: $text)
            
            HStack {
                Text("Vote").contextMenu {
                    ForEach(0..<5, id: \.self) { vote in
                        Button(action: {
                            self.starVoted = String(vote + 1)
                            self.starVotedInt = vote + 1
                        }, label: {
                            Text("Choose star to vote: \(vote + 1)")
                            Image(systemName: "star.fill")
                        })
                    }
                }
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                .background(Color.green)
                .cornerRadius(10)
                Spacer()
                    .alert(isPresented: $isReviewed) {
                        Alert(title: Text("Success"),
                              message: Text("You just reviewed for \(restaurant.name)"),
                              dismissButton: .default(Text("OK")))
                    }
                Spacer()
                Spacer()
                Spacer()
                HStack{
                    if self.starVotedInt < 3 {
                        Text("\(starVoted)")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.red)
                    }
                    if self.starVotedInt == 3 {
                        Text("\(starVoted)")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.yellow)
                    }
                    if self.starVotedInt > 3 {
                        Text("\(starVoted)")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.green)
                    }
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    Spacer()
                }
                
            }
            Button(action: {
                self.restaurantService.ReviewRestaurant(request: ReviewRestaurantRequest(userID: self.userID, restaurantID: self.restaurant.id, rank: starVotedInt, text: self.text)) { resp in
                    if resp.isSuccess {
                        self.isReviewed = true
                        self.parentVm.details?.rank = Int(resp.rank)
                        self.parentVm.details?.reviews = resp.reviews
                    }
                }
            }, label: {
                Text("Finish")
                    .bold()
                    .frame(width: 80, height: 40, alignment: .center)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }).padding(.top)
            
            Spacer()
        }
        .navigationBarTitle("Review")
        .padding(22)
    }
}

//struct ReviewRestaurant_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ReviewRestaurant(userID: 1)
//        }
//    }
//}
