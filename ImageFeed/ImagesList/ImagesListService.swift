
import Foundation

final class ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let urlSession = URLSession.shared
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        assert(Thread.isMainThread)
        guard task == nil else {return}
        let path = "/photos?page=\(nextPage)"
        var request = URLRequest.makeHTTPRequest(path: path, httpMethod: "GET")
       
        request.setValue("Bearer \(OAuth2TokenStorage().token!)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let photosList):
                for photo in photosList {
                    self.photos.append(Photo(
                        id: photo.id,
                        size: CGSize(width: photo.width, height: photo.height),
                        createdAt: self.convertDate(stringDate: photo.createdAt ?? ""),
                        welcomeDescription: photo.description ?? "",
                        thumbImageURL: photo.urls.thumb,
                        largeImageURL: photo.urls.full,
                        isLiked: photo.likedByUser))
                    self.task = nil
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["photos": self.photos])
                }
            case .failure(let error):
                print(error)
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func convertDate(stringDate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd’T’HH:mm:ss"
        return stringDate == "" ? Date() : formatter.date(from: stringDate)
    }

    
}
