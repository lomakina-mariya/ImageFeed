
import Foundation

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func viewDidLoad()
    func convertDate(photo: Photo) -> String
    func findImageHeight(index: Int, imageViewWidth: CGFloat) -> CGFloat
    func shouldGetNewPhotos(photoNumber: Int)
    func changeLike(index: Int, cell: ImagesListCell)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private let imagesListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) {[weak self] _ in
                    guard let self = self else { return }
                    self.updateTable()
                }
        self.imagesListService.fetchPhotosNextPage()
    }
    
    func shouldGetNewPhotos(photoNumber: Int) {
        if photoNumber + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func convertDate(photo: Photo) -> String {
        return photo.createdAt == nil ? "" : dateFormatter.string(from: photo.createdAt!)
    }
    
    func findImageHeight(index: Int, imageViewWidth: CGFloat) -> CGFloat {
        let image = photos[index]
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let imageHeight = image.size.height * scale
        return imageHeight
    }
    
    func updateTable() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            self.view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func changeLike(index: Int, cell: ImagesListCell) {
        let photo = photos[index]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) {[weak self] (result: Result<Like, Error>) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos[index].isLiked.toggle()
                cell.setIsLiked(isLikeButton: self.photos[index].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                print(error)
                UIBlockingProgressHUD.dismiss()
                
            }
        }
    }
}
