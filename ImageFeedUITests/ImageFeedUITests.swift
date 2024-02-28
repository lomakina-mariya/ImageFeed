
import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    private let login = "@lomasha"
    private let email = "lomakina.ms@gmail.com"
    private let password = "UjVEq9CkzbGDq5!"
    private let lastName = "Mariya Lomakina"

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(email)
        loginTextField.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        sleep(3)
        passwordTextField.tap()
        passwordTextField.typeText(password)
        passwordTextField.swipeUp()
        
        print(app.debugDescription)
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
       
//        cellToLike.buttons["likeButtonOn"].tap()
//        sleep(2)
//        cellToLike.buttons["likeButtonOn"].tap()
//        sleep(2)
        
        cellToLike.tap()
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        app.buttons["Back"].tap()
    }
    
    func testProfile() throws {
        sleep(3)
        print(app.debugDescription)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(2)
        
        XCTAssertTrue(app.staticTexts[lastName].exists)
        XCTAssertTrue(app.staticTexts[login].exists)
        
        app.buttons["Logout"].tap()
        sleep(2)
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
        
        XCTAssertTrue(app.buttons["Authenticate"].exists)
        
    }
}
