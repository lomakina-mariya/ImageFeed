
import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    private var task: URLSessionTask?
    
   
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else {return}
        var request = URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = profileData(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = Profile(username: profile.username, firstName: profile.firstName, lastName: profile.lastName, bio: profile.bio)
                completion(.success(self.profile!))
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

extension ProfileService {
    private func profileData(for request: URLRequest,completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let response = response,
                   let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200..<300 ~= statusCode {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        guard let profile = try? decoder.decode(ProfileResult.self, from: data) else {
                            completion(.failure(NetworkError.invalidDecoding))
                            return
                        }
                        completion(.success(profile))
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

  private struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String
        let bio: String
    }
}


struct Profile {
    let username: String
    let firstName: String
    let lastName: String
    var name: String {
        return firstName + " " + lastName
    }
    var loginName: String {
        return "@" + username
    }
    var bio: String

}
