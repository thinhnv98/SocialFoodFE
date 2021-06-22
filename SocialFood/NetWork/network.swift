import Foundation
import Network

enum NetworkError: Error {
    case decodingError
    case noResultError
    case keyError
    case notFoundError
    case forbiddenError
    case serverError
    case unknownError
    var localizedDescription: String {
        switch self {
        case .notFoundError:
            return "The request cannot be fulfilled because the resource does not exist."
        case .decodingError:
            return "Decoding data error."
        case .noResultError:
            return "No matching result found."
        case .keyError:
            return "Key is invalid or expired."
        case .forbiddenError:
            return "The request is not allowed."
        case .serverError:
            return "The request failed due to a server-side error."
        case .unknownError:
            return "Unknown error"
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

class ResponseObject<T: Codable> {
    var url: URL
    var httpMethod: HttpMethod = .get
    var body: Data?
    init(url: URL) {
        self.url = url
    }
}

class NetworkProvider {
    let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
       self.urlSession = urlSession
     }

    func request(requestUrl: URL,
                 httpMethod: HttpMethod = .get,
                 parameters: [String: Any]? = nil,
                 completion: @escaping (_ responseData: Data?, _ networkError: NetworkError?) -> Void) {
        var request = URLRequest(url: requestUrl)
        request.httpMethod = httpMethod.rawValue

        switch httpMethod {
        case .get:
            request.httpBody = nil
        case .post:
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters!, options: []) else {
                print("parameters is nil")
                return
            }
            request.httpBody = httpBody
        }
        urlSession.dataTask(with: request) { data, response, error in
            guard let urlResponse = response, let data = data, error == nil else {
                completion(nil, .unknownError)
                return
            }
            let httpResponse = urlResponse as! HTTPURLResponse
            switch httpResponse.statusCode {
            case 404:
                completion(nil, .notFoundError)
            case 400, 401:
                completion(nil, .keyError)
            case 403:
                completion(nil, .forbiddenError)
            case 500:
                completion(nil, .serverError)
            case 200..<300:
                completion(data, nil)
            default:
                completion(nil, .unknownError)
            }
        }.resume()
    }
}
