import UIKit
import WebKit

final class HelperViewController: UIViewController, WKNavigationDelegate {
    private let urlString: String
    private var webView: WKWebView!
    var onHashAction: ((String) -> Void)?

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: config)
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)

        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let fragment = webView.url?.fragment {
            onHashAction?(fragment)
        }
    }
}

extension UIViewController {
    func openHelper(url: String, onHashAction: ((String) -> Void)? = nil) {
        let vc = HelperViewController(urlString: url)
        vc.onHashAction = onHashAction
        present(vc, animated: true)
    }
}
