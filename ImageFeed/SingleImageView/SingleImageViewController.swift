
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var urlString: String? {
        didSet {
            loadPhoto()
        }
    }
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else {return}
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image ?? UIImage(named: "stub")!)
        }
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        rescaleAndCenterImageInScrollView(image: image ?? UIImage(named: "stub")!)
    }
    
    // MARK: - @IBAction private func
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [image as Any],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    // MARK: - private func
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let hScale = visibleRectSize.width / image.size.width
        let vScale = visibleRectSize.height / image.size.height
        let theoreticalScale = max(hScale, vScale)
        let scale = min(maxZoomScale, max(minZoomScale, theoreticalScale))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func loadPhoto() {
        guard let url = URL(string: urlString!) else { return }
        let imageView = UIImageView()
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
            case .failure(let error):
                self.showError()
                print(error)
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert)
        let alertActionNo = UIAlertAction(title: "Не надо", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
            }
        let alertActionTryAgain = UIAlertAction(title: "Повторить", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.loadPhoto()
            }
        alert.addAction(alertActionNo)
        alert.addAction(alertActionTryAgain)
        let vc = self.presentedViewController ?? self
        vc.present(alert, animated: true)
    }
}

// MARK: - Extensions SingleImageViewController

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
