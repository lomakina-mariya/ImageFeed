
import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private let urlSession = URLSession.shared
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    
   
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else {return}
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        let task = processing(of: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let userResult):
                self.avatarURL = userResult.profileImage["small"]
                completion(.success(self.avatarURL!))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": self.avatarURL!])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

// MARK: - Network Connection

extension ProfileImageService {
    private func processing(of request: URLRequest,completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200..<300 ~= statusCode {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        guard let avatar = try? decoder.decode(UserResult.self, from: data) else {
                            completion(.failure(NetworkError.invalidDecoding))
                            return
                        }
                        completion(.success(avatar))
                    }
                    else {
                        completion(.failure(error ?? NetworkError.httpStatusCode(statusCode)))
                        return
                    }
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

  private struct UserResult: Codable {
      var profileImage: [String: String]
    }
}

