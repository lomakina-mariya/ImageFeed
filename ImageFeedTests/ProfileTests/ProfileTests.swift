@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    
    func testShowAlert() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenter(view: viewController)
        viewController.presenter = presenter
        
        //when
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
        window.rootViewController = viewController
        presenter.makeAlert()
        
        //then
        sleep(5)
        XCTAssertNotNil(viewController.presentedViewController)
    }
}
