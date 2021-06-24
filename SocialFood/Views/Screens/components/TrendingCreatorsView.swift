//
//  TrendingCreatorsView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import SwiftUI

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

struct TrendingCreatorsView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingCreatorsView()
    }
}
