import Foundation
import UIKit

protocol URLViewControllerDelegate {
    func addToFavorites(entry: EntryViewModel) -> Bool
    func removeFromFavorites(entry: EntryViewModel) -> Bool
}

class URLViewController: UIViewController {
    
    var isFav = false
    var entry: EntryViewModel!
    var delegate: URLViewControllerDelegate!
    
    @IBOutlet private weak var webView: UIWebView!
    
    fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    fileprivate var favButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.activityIndicatorView.startAnimating()

        if let url = entry.url {
            self.webView.loadRequest(URLRequest(url: url))
        }
        
        favButton = UIBarButtonItem(image: UIImage(named: "star-full-icon"), style: .done, target: self, action: #selector(URLViewController.toggleFav))
        self.navigationItem.rightBarButtonItems = [favButton, UIBarButtonItem(customView: self.activityIndicatorView)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavButton()
    }
    
    @objc func toggleFav() {
        var done = false
        if isFav {
            done = delegate.removeFromFavorites(entry: entry)
        } else {
            done = delegate.addToFavorites(entry: entry)
        }
        
        if done {
            isFav = !isFav
            updateFavButton()
        }
    }
    
    private func updateFavButton() {
        let favIconName = isFav ? "star-full-icon" : "star-empty-icon"
        favButton.image = UIImage(named: favIconName)
    }
}

extension URLViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {

        self.activityIndicatorView.stopAnimating()
    }
}
