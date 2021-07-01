//
//  CreatorDetailsView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 01/07/2021.
//

import SwiftUI

struct DiscoverCreatorView: View {
    
    let creator: Creator
    
    var body: some View {
        VStack{
            Image(creator.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .cornerRadius(60)
            Text(creator.name)
                .font(.system(size: 11, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.label))
        }
        .frame(width: 60)
        .shadow(color: .gray, radius: 4, x: 0.0, y: 2)
    }
}
