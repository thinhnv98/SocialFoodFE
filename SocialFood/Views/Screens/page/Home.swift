//
//  HomePlus.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 23/06/2021.
//

import Foundation
import SwiftUI

extension Color {
    static let discoverBackground = Color(.init(white: 0.95, alpha: 1))
}

struct HomeView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    var body: some View{
        NavigationView{
            ZStack{
                //backgound color
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9989364743, green: 0.6389529705, blue: 0.1817156971, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.4949038029, blue: 0.009055896662, alpha: 1))]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                
                
                Color.discoverBackground
                    .offset(y: 400)
                
                ScrollView{
                    
                    HStack{
                        Image(systemName: "magnifyingglass")
                        Text("Where you want to go?")
                        Spacer()
                            
                    }.font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(.init(white: 1, alpha: 0.3)))
                    .cornerRadius(10)
                    .padding(16)
                    
                    DiscoverCategoriesView()
                    
                    VStack{
                        
                        PopularDestinationsView()
                        
                        PopularRestaurantsView()
                        
                        TrendingCreatorsView()
                    }.background(Color.discoverBackground)
                    .cornerRadius(16)
                    .padding(.top, 32)
                }
            }
            .navigationTitle("Social Travels")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
