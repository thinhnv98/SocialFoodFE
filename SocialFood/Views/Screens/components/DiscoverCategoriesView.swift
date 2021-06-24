//
//  DiscoverCategoriesView.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 24/06/2021.
//

import SwiftUI

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
                    NavigationLink(
                        destination: CategoryDetailsView(),
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

struct CategoryDetailsView: View {
    var body: some View{
        ScrollView {
            ForEach(0..<5, id: \.self) { num in
                VStack(alignment: .leading, spacing: 0){
                    Image("1.paintershop")
                        .resizable()
                        .scaledToFill()
                    Text("Demo123")
                        .font(.system(size: 12, weight: .semibold))
                        .padding()
                        
                }.asTile()
                .padding()
            }
        }.navigationBarTitle("Category", displayMode: .inline)
    }
}

struct DiscoverCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            CategoryDetailsView()
        }
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
