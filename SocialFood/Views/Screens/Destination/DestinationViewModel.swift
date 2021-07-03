//
//  DestinationViewModel.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 03/07/2021.
//

import Foundation
import SwiftUI

struct DestinationsResult: Decodable {
    var result: [Destination]
}

class DestinationViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var destinations: [Destination]?
    
    init() {
        //make a network call
//        let name = "paris"
        let fixedUrlString = "http://localhost:8080/api/destinations".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: fixedUrlString)
        else {return}
        URLSession.shared.dataTask(with: url) { data, resp, err in
            //make sure to check your err & resp

            DispatchQueue.main.async {
                guard let data = data else {return}
                do {
                    let result = try JSONDecoder().decode(DestinationsResult.self, from: data)
            
                    self.destinations = result.result
                } catch {
                    print("Failed to decode JSON, ", error)
                }
            }
        }.resume()
    }
}
