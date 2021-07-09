//
//  TrendingCreatorsView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import SwiftUI
import Kingfisher

//      https://travel.letsbuildthatapp.com/travel_discovery/user?id=0

struct CreatorDetail: Decodable {
    let username, firstName, lastName, profileImage: String
    let followers, following: Int
    let posts: [Post]
}

struct Post: Decodable, Hashable {
    let title, imageUrl, views: String
    let hashtags: [String]
}

class TrendingCreatorsViewModel: ObservableObject {
    
    @Published var creatorDetails: CreatorDetail?
    
    init(creatorID: Int) {
        // network code
        guard let url = URL(string: "https://travel.letsbuildthatapp.com/travel_discovery/user?id=\(creatorID)") else {return}
        
        URLSession.shared.dataTask(with: url) { data, resp, err in
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                
                do {
                    self.creatorDetails = try JSONDecoder().decode(CreatorDetail.self, from: data)
                } catch let jsonErr {
                    print("Decoding failed for CreatorDetails: ", jsonErr)
                }
                print(data)
            }
        }.resume()
    }
    
}

struct TrendingCreatorsView: View{
    
    let creators: [Creator] = [
        .init(id: 0, name: "Amy Adams", imageName: "1.amyadams"),
        .init(id: 1, name: "Billy Childs", imageName: "1.billychilds"),
        .init(id: 2, name: "Sam Smith", imageName: "1.samsmith"),
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
                        
                        NavigationLink (
                            destination: NavigationLazyView(CreatorDetailView(creator: creator)) ,
                            label: {
                                DiscoverCreatorView(creator: creator)
                            })
                        
                    }
                }.padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

struct CreatorDetailView: View {
    
    @ObservedObject var vm: TrendingCreatorsViewModel
    let creator: Creator
    
    init(creator: Creator) {
        self.creator = creator
        self.vm = .init(creatorID: creator.id)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                
                Image(creator.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding(.horizontal)
                    .padding(.top)
                
                Text("\(self.vm.creatorDetails?.firstName ?? "") \(self.vm.creatorDetails?.lastName ?? "")")
                    .font(.system(size: 14, weight: .semibold))
                
                HStack {
                    Text("@\(self.vm.creatorDetails?.username ?? "") •")
                        
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.system(size: 10, weight: .semibold))
                    
                    Text("2541")
                }
                .font(.system(size: 12, weight: .regular))
                
                Text("Youtuber, Vlogger, Travel Creator")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.lightGray))
                
                HStack(spacing: 12) {
                    VStack {
                        Text("59,394")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Followers")
                            .font(.system(size: 9, weight: .regular))
                    }
                    
                    Spacer()
                        .frame(width: 0.5, height: 12)
                        .background(Color(.lightGray))
                    
                    VStack {
                        Text("2,112")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Following")
                            .font(.system(size: 9, weight: .regular))
                    }
                }
                
                HStack(spacing: 12) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        HStack {
                            Spacer()
                            Text("Follow")
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color.orange)
                        .cornerRadius(100)
                    })
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        HStack {
                            Spacer()
                            Text("Contact")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                        .background(Color(white: 0.9))
                        .cornerRadius(100)
                    })
                }
                .font(.system(size: 11, weight: .semibold))
                
                ForEach(vm.creatorDetails?.posts ?? [], id: \.self) { post in
                    VStack(alignment: .leading) {
                        KFImage(URL(string: post.imageUrl))
//                        Image("1.japan")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .clipped()
                        
                        HStack {
                            Image(creator.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 34)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(post.title)
                                    .font(.system(size: 14, weight: .semibold))
                                
                                Text("\(post.views) views")
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                                    
                            }
                        }.padding(.horizontal, 12)
                        
                        HStack {
                            ForEach(post.hashtags, id: \.self) { hashtag in
                                Text("#\(hashtag)")
                                    .foregroundColor(Color(#colorLiteral(red: 0.2569929957, green: 0.5958017111, blue: 0.8776248097, alpha: 1)))
                                    .font(.system(size: 13, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color(#colorLiteral(red: 0.8936722875, green: 0.9387666583, blue: 1, alpha: 1)))
                                    .cornerRadius(20)
                            }.padding(.bottom)
                            .padding(.horizontal, 2)
                        }
                        
                        
                    }
//                    .frame(height: 200)
                    .background(Color(white: 1))
                    .cornerRadius(12)
                    .shadow(color: .init(white: 0.8), radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 4)
                }
                
            }.padding(.horizontal)
        }
        .navigationBarTitle(creator.name, displayMode: .inline)
    }
}


//struct TrendingCreatorsView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
