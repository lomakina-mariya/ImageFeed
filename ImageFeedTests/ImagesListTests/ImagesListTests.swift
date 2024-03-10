
@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy(view: viewController)
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalledForTest)
    }
    
    func testConvertDate() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter(view: viewController)
        viewController.presenter = presenter
        let photo = Photo(id: "1", size: CGSize(width: 70, height: 70), createdAt: Date(), welcomeDescription: "Hello", thumbImageURL: "", largeImageURL: "", isLiked: false)
        
        //when
        let date = presenter.convertDate(photo: photo)
        
        //then
        XCTAssertEqual(date, "03 марта 2024")
    }
    
    func testImageHeight() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy(view: viewController)
        viewController.presenter = presenter
        
        //when
        let imageHeight = presenter.findImageHeight(index: 0, imageViewWidth: CGFloat(integerLiteral: 80))
        
        //then
        XCTAssertEqual(imageHeight, CGFloat(integerLiteral: 80))
    }
    
    func testChangeLike() {
        //given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy(view: viewController)
        viewController.presenter = presenter
        
        //when
        presenter.changeLike(index: 0, cell: ImagesListCell())
        
        //then
        XCTAssertTrue(presenter.photosForTest[0].isLiked)
    }
}
