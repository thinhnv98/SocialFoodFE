//
//  PopularDestinationsView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import SwiftUI

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
                        .asTile()
                        .padding(.bottom)
                    }
                }.padding(.horizontal)
            }
        }
    }
}

struct PopularDestinationsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularDestinationsView()
    }
}
