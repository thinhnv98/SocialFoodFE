//
//  FoodWithTitleAndType.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 23/06/2021.
//

import Foundation
import SwiftUI

struct FoodWithTitleAndType: View{
    var body: some View{
        VStack{
            VStack{
                RemoteImage(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7O3jULOTqGu89Lb2gzuw3wt25wpM9HRQNNoiclO7qdmmdfYYIuVjzIjCxLhb0rxmFQFY&amp;usqp=CAU")
            }
            .cornerRadius(20)
            
            Text("Title")
            Text("Type")
        }
        .frame(width: 150, height: 180)
        .padding()
        .shadow(radius: 30)
    }
}
