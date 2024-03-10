
import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var photos: [ImageFeed.Photo] = []
    var photosForTest: [Photo] = [Photo(
        id: "1",
        size: CGSize(width: 70, height: 70),
        createdAt: Date(),
        welcomeDescription: "Hello",
        thumbImageURL: "",
        largeImageURL: "",
        isLiked: false
    )]
    var viewDidLoadCalledForTest: Bool = false
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        viewDidLoadCalledForTest = true
    }
    
    func convertDate(photo: ImageFeed.Photo) -> String {
       return ""
    }
    
    func findImageHeight(index: Int, imageViewWidth: CGFloat) -> CGFloat {
        let image = photosForTest[index]
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let imageHeight = image.size.height * scale
        return imageHeight
    }
    
    func shouldGetNewPhotos(photoNumber: Int) {
       
    }
    
    func changeLike(index: Int, cell: ImagesListCell) {
        _ = photosForTest[index]
        self.photosForTest[index].isLiked.toggle()
    }
    
    struct Photo {
        let id: String
        let size: CGSize
        let createdAt: Date?
        let welcomeDescription: String?
        let thumbImageURL: String
        let largeImageURL: String
        var isLiked: Bool
    }

}
