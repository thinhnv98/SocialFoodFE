//
//  RestaurantViewModel.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 04/07/2021.
//

import Foundation

struct RestaurantResult: Decodable {
    var result: [Restaurant]
}

struct DishesResult: Decodable {
    var result: [Dish]
}

class RestaurantViewModel: ObservableObject {
    @Published var restaurants: [Restaurant]?
    
    init() {
        let fixedUrlString = "http://localhost:8080/api/restaurants".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: fixedUrlString)
        else {return}
        URLSession.shared.dataTask(with: url) { data, resp, err in
            //make sure to check your err & resp

            DispatchQueue.main.async {
                guard let data = data else {return}
                do {
                    let result = try JSONDecoder().decode(RestaurantResult.self, from: data)
            
                    self.restaurants = result.result
                } catch {
                    print("Failed to decode JSON, ", error)
                }
            }
        }.resume()
    }
}
