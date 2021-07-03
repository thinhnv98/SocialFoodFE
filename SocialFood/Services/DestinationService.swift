//
//  DestinationService.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 03/07/2021.
//

import Foundation

struct CreateDestinationResponse: Codable {
    var isSuccess: Bool
}

class DestinationService: ObservableObject {
    let networkProvider = NetworkProvider()
    static let createURL = URL(string: "http://localhost:8080/api/create-destination")
    static let getURL = URL(string: "http://localhost:8080/api/destinations")
    static let voteURL = URL(string: "http://localhost:8080/api/destination/vote")
    
    func CreateNewDestination(destination: Destination, completion: @escaping (CreateDestinationResponse) -> ()){
        self.CreateNewDestinationAPI(destination: destination) { result in
            switch result {
            case.failure(let error):
                print("ErrorNetWork: \(error)")
                completion(CreateDestinationResponse(isSuccess: false))
            case.success(let registerResponse):
                completion(registerResponse)
            }
        }
    }
    
    func GetDestination(completion: @escaping(DestinationsResult) -> ()) {
        self.GetDestinationsAPI { result in
            switch result {
                case.failure(let err):
                    print("ErrorNetWork: \(err)")
                case .success(let data):
                    completion(data)
            }
        }
    }
    
    func VoteDestination(destinationVote: DestinationVote, completion: @escaping(RankResponse) -> ()) {
        self.VoteDestinationAPI(destinationVote: destinationVote) { result in
            switch result {
                case.failure(let err):
                    print("ErrorNetWork: \(err)")
                case .success(let data):
                    completion(data)
            }
        }
    }
    
    //Network
    
    func CreateNewDestinationAPI(destination: Destination, completion: @escaping (Result<CreateDestinationResponse, NetworkError>) -> Void) {
        //prepare request
        let parameters: [String: Any] = [
            "name": destination.name,
            "country": destination.country,
            "imageName": destination.imageName,
            "imageData": destination.imageData,
            "description": destination.description,
            "latitude": destination.latitude,
            "longitude": destination.longitude,
        ]
        
        self.networkProvider.request(requestUrl: Self.createURL!, httpMethod: HttpMethod.post, parameters: parameters) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            let createDestinationResponse = try? JSONDecoder().decode(CreateDestinationResponse.self, from: data!)
            if let createDestinationResponse = createDestinationResponse {
                completion(.success(createDestinationResponse))
            } else {
                completion(.failure(NetworkError.noResultError))
            }
        }
    }
    
    func GetDestinationsAPI(completion: @escaping (Result<DestinationsResult, NetworkError>) -> Void) {
        self.networkProvider.request(requestUrl: Self.getURL!) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            let destinationsResult = try? JSONDecoder().decode(DestinationsResult.self, from: data!)
            if let destinationsResult = destinationsResult {
                completion(.success(destinationsResult))
            } else {
                completion(.failure(NetworkError.noResultError))
            }
        }
    }
    
    func VoteDestinationAPI(destinationVote: DestinationVote, completion: @escaping (Result<RankResponse, NetworkError>) -> Void) {
        //prepare request
        let parameters: [String: Any] = [
            "destination_id": destinationVote.destinationID,
            "vote": destinationVote.vote
        ]
        self.networkProvider.request(requestUrl: Self.voteURL!, httpMethod: HttpMethod.post, parameters: parameters) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            
            let status = try? JSONDecoder().decode(RankResponse.self, from: data!)
            if let status = status {
                completion(.success(status))
            } else {
                completion(.failure(NetworkError.noResultError))
            }
        }
    }
}
