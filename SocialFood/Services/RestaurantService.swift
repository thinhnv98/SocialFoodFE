//
//  Restaurant.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 04/07/2021.
//

import Foundation

class RestaurantService: ObservableObject {
    let networkProvider = NetworkProvider()
    static let createURL = URL(string: "http://localhost:8080/api/create-restaurant")
    static let getURL = URL(string: "http://localhost:8080/api/restaurants")
    static let createDishURL = URL(string: "http://localhost:8080/api/create-dish")
    static let reviewRestaurantURL = URL(string: "http://localhost:8080/api/review-restaurant")
    
    func CreateNewRestaurant(restaurant: RestaurantCreateRequest, completion: @escaping (StatusResponse) -> ()){
        self.CreateNewRestaurantAPI(restaurant: restaurant) { result in
            switch result {
            case.failure(let error):
                print("ErrorNetWork: \(error)")
                completion(StatusResponse(isSuccess: false))
            case.success(let status):
                completion(status)
            }
        }
    }
    
    func CreateNewDish(restaurantID: Int, dish: Dish, completion: @escaping (StatusResponse) -> ()){
        self.CreateNewDishAPI(restaurantID: restaurantID, dish: dish) { result in
            switch result {
            case.failure(let error):
                print("ErrorNetWork: \(error)")
                completion(StatusResponse(isSuccess: false))
            case.success(let status):
                completion(status)
            }
        }
    }
    
    func GetRestaurant(completion: @escaping(RestaurantResult) -> ()) {
        self.GetRestaurantAPI { result in
            switch result {
                case.failure(let err):
                    print("ErrorNetWork: \(err)")
                case .success(let data):
                    completion(data)
            }
        }
    }
    
    func GetDishes(restaurantID: Int, completion: @escaping(DishesResult) -> ()) {
        self.GetDishesAPI(restaurantID: restaurantID) { result in
            switch result {
                case.failure(let err):
                    print("ErrorNetWork: \(err)")
                case .success(let data):
                    completion(data)
            }
        }
    }
    
    func ReviewRestaurant(request: ReviewRestaurantRequest, completion: @escaping(RestaurantReviewResponse) -> ()) {
        self.ReviewRestaurantAPI(request: request) { result in
            switch result {
                case.failure(let err):
                    print("ErrorNetWork: \(err)")
                case .success(let data):
                    completion(data)
            }
        }
    }
    
    //Network
    func CreateNewRestaurantAPI(restaurant: RestaurantCreateRequest, completion: @escaping (Result<StatusResponse, NetworkError>) -> Void) {
        //prepare request
        let parameters: [String: Any] = [
            "name": restaurant.name,
            "city": restaurant.city,
            "country": restaurant.country,
            "imageName": restaurant.imageName,
            "imageData": restaurant.imageData,
            "description": restaurant.description,
        ]
        
        self.networkProvider.request(requestUrl: Self.createURL!, httpMethod: HttpMethod.post, parameters: parameters) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            let status = try? JSONDecoder().decode(StatusResponse.self, from: data!)
            if let status = status {
                completion(.success(status))
            } else {
                completion(.failure(NetworkError.noResultError))
            }
        }
    }
    
    func GetRestaurantAPI(completion: @escaping (Result<RestaurantResult, NetworkError>) -> Void) {
        self.networkProvider.request(requestUrl: Self.getURL!) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            let result = try? JSONDecoder().decode(RestaurantResult.self, from: data!)
            if let result = result {
                completion(.success(result))
            } else {
                completion(.failure(NetworkError.noResultError))
            }
        }
    }
    
    
    func CreateNewDishAPI(restaurantID: Int, dish: Dish, completion: @escaping (Result<StatusResponse, NetworkError>) -> Void) {
        //prepare request
        let parameters: [String: Any] = [
            "restaurantID": restaurantID,
            "name": dish.name,
            "price": dish.price,
            "photo": dish.photo,
            "numPhotos": dish.numPhotos
        ]
        
        self.networkProvider.request(requestUrl: Self.createDishURL!, httpMethod: HttpMethod.post, parameters: parameters) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            let status = try? JSONDecoder().decode(StatusResponse.self, from: data!)
            if let status = status {
                completion(.success(status))
            } else {
                completion(.failure(NetworkError.noResultError))
            }
        }
    }
    
    func GetDishesAPI(restaurantID: Int, completion: @escaping (Result<DishesResult, NetworkError>) -> Void) {
        self.networkProvider.request(requestUrl: URL(string: "http://localhost:8080/api/restaurants-dishes/\(restaurantID)")!) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            let result = try? JSONDecoder().decode(DishesResult.self, from: data!)
            if let result = result {
                completion(.success(result))
            } else {
                completion(.failure(NetworkError.noResultError))
            }
        }
    }
    
    func ReviewRestaurantAPI(request: ReviewRestaurantRequest, completion: @escaping (Result<RestaurantReviewResponse, NetworkError>) -> Void) {
        //prepare request
        let parameters: [String: Any] = [
            "userID": request.userID,
            "restaurantID": request.restaurantID,
            "rank": request.rank,
            "text": request.text,
        ]
        
        self.networkProvider.request(requestUrl: Self.reviewRestaurantURL!, httpMethod: HttpMethod.post, parameters: parameters) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            let status = try? JSONDecoder().decode(RestaurantReviewResponse.self, from: data!)
            if let status = status {
                completion(.success(status))
            } else {
                completion(.failure(NetworkError.noResultError))
            }
        }
    }
}
