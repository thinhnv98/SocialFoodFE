//
//  UserService.swift
//  SocialFood
//
//  Created by Thịnh Nguyễn on 21/06/2021.
//

import Foundation
struct LoginResponse: Codable {
    var IsSuccess: Bool
}

struct RegisterResponse: Codable {
    var IsExisted: Bool
    var IsSuccess: Bool
}


class UserService: ObservableObject {
    @Published var isSuccess = false
    let networkProvider = NetworkProvider()
    let group = DispatchGroup()
    static let loginURL = URL(string: "http://localhost:8080/api/login")
    static let registerURL = URL(string: "http://localhost:8080/api/register")
    
    func Authenticate(user: User, completion: @escaping (Bool) -> ()) {
        self.LoginAPI(user: user) { result in
            switch result {
            case.failure(let error):
                print("Error: \(error)")
                completion(false)
            case.success(let isSuccess):
                completion(isSuccess.IsSuccess)
            }
            
        }
    }
    
    func Register(user: User, completion: @escaping (RegisterResponse) -> ()) {
        self.RegisterAPI(user: user ) { result in
            switch result {
            case.failure(let error):
                print("ErrorNetWork: \(error)")
                completion(RegisterResponse(IsExisted: false, IsSuccess: false))
            case.success(let registerResponse):
                completion(registerResponse)
            }
        }
    }
    
    //NET WORK
    func LoginAPI(user: User, completion: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        //prepare request
        let parameters: [String: Any] = [
            "email": user.Email,
            "password": user.Password,
            "type": user.AccountType
        ]
        self.networkProvider.request(requestUrl: Self.loginURL!, httpMethod: HttpMethod.post, parameters: parameters) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data!)
            if let loginResponse = loginResponse {
                completion(.success(loginResponse))
            } else {
                completion(.failure(NetworkError.noResultError))
            }

        }
    }
    
    func RegisterAPI(user: User, completion: @escaping (Result<RegisterResponse, NetworkError>)->Void){
        //prepare request
        let parameters: [String: Any] = [
            "email": user.Email,
            "password": user.Password,
            "type": user.AccountType
        ]
        self.networkProvider.request(requestUrl: Self.registerURL!, httpMethod: HttpMethod.post, parameters: parameters) { (data, networkError) in
            if let networkError = networkError {
                completion(.failure(networkError))
                return
            }
            let registerResponse = try? JSONDecoder().decode(RegisterResponse.self, from: data!)
            if let registerResponse = registerResponse {
                completion(.success(registerResponse))
            } else {
                completion(.failure(NetworkError.noResultError))
            }
        }
    }
}
