
import Foundation
import UIKit
import ImageFeed

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var didUpdateTable: Bool = false
    
    override func viewDidLoad() {
    }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        didUpdateTable = true
    }
    
    
}
