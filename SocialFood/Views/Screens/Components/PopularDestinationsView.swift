//
//  PopularDestinationsView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import SwiftUI
import MapKit

struct PopularDestinationsView: View{
    
    let destinations: [Destination] = [
        .init(name: "Paris", country: "France", imageName: "1.eiffel", latitude: 48.855014, longitude: 2.341231),
        .init(name: "Tokyo", country: "Japan", imageName: "1.japan", latitude: 35.67988, longitude: 139.7695),
        .init(name: "New York", country: "US", imageName: "1.newyork", latitude: 40.71592, longitude: -74.0055),
    ]
    
    var body: some View{
        VStack{
            HStack{
                Text("Popular destinations")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
                Text("See all")
                    .font(.system(size: 12, weight: .semibold))
            }.padding(.horizontal)
            .padding(.top)
            
            
        }
    }
}
