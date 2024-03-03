
import Foundation
import UIKit
import ImageFeed

final class WebViewViewControllerSpy: UIViewController, WebViewViewControllerProtocol {
    var loadRequestCalled: Bool = false
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
    
}
