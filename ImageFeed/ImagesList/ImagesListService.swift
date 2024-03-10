
import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    static let shared = ImagesListService()
    private let urlSession = URLSession.shared
    private let formatter = ISO8601DateFormatter()
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        assert(Thread.isMainThread)
        guard task == nil else {return}
        let path = "/photos?page=\(nextPage)&per_page=10"
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: "GET")
        request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosList):
                photosList.forEach { photoResult in
                    self.photos.append(Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: self.formatter.date(from: photoResult.createdAt ?? ""),
                        welcomeDescription: photoResult.description ?? "",
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: photoResult.likedByUser))
                }
                self.task = nil
                self.lastLoadedPage = nextPage
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: nil)
                
            case .failure(let error):
                print(error)
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Like, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard task == nil else {return}
        let path = "/photos/\(photoId)/like"
        let method = isLike ? "DELETE" : "POST"
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: method)
        request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<Like, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let like):
                completion(.success(like))
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index].isLiked.toggle()
                }
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}
