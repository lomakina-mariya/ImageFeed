
import Foundation

// MARK: - Network Connection

extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let completionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    guard let object = try? decoder.decode(T.self, from: data) else {
                        completionOnMainThread(.failure(NetworkError.invalidDecoding))
                        return
                    }
                    completionOnMainThread(.success(object))
                }
                else {
                    completionOnMainThread(.failure(error ?? NetworkError.httpStatusCode(statusCode)))
                    return
                }
            }
        }
        return task
    }
    
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case invalidDecoding
    }
}

// MARK: - HTTP Request

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = AuthConfiguration.standard.defaultBaseURL,
        urlQueryItem: [URLQueryItem] = []
    ) -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {fatalError("Failed to create URL")}
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

