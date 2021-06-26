//
//  DiscoverCategoriesView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct DiscoverCategoriesView: View {
    
    let categories: [Category] = [
        .init(name: "Art", imageName: "paintpalette.fill"),
        .init(name: "Sports", imageName: "sportscourt.fill"),
        .init(name: "Live Events", imageName: "music.mic"),
        .init(name: "Food", imageName: "tray.fill"),
        .init(name: "History", imageName: "books.vertical.fill"),
    ]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 14){
                ForEach(categories, id: \.self ) { category in
                    NavigationLink(
                        destination: NavigationLazyView(CategoryDetailsView(name: category.name)),
                        label: {
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
                        })
                }
            }
            .padding(.horizontal)
        }
    }
}





struct DiscoverCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
//        ZStack{
//            Color.orange
//            DiscoverCategoriesView()
//        }
        
//        NavigationView{
//            NavigationLink(
//                destination: Text("Transition Screen"),
//                label: {
//                    Text("Link")
//                })
//        }
    }
}
