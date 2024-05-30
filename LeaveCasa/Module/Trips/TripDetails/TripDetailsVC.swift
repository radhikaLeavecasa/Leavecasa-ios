import UIKit
import WebKit
import IBAnimatable

class TripDetailsVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnDownload: AnimatableButton!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var webView: WKWebView!
    //MARK: - Variables
    var bookingId = String()
    var type = Int()
    var isDetailScreen = false
    var urlString = String()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        btnDownload.isHidden = title != AlertMessages.INVOICE && title != "E-ticket"
        lblHeader.text = title
        switch title {
        case AlertMessages.INVOICE :
            if let url = URL(string: type == 2 ? "\(baseUrl)/bus/invoice/\(bookingId)" : type == 3 ? "\(baseUrl)/hotel/invoice/\(bookingId)" : type == 4 ? "\(baseUrl)/insurance/invoice/\(bookingId)" : "\(baseUrl)/flight/invoice/\(bookingId)") {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        case "About Us", "Expert Curator":
            if let url = URL(string: "https://leavecasa.com/about-us") {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        case "Privacy Policy":
            if let url = URL(string: "https://leavecasa.com/privacy-policy") {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        case "Terms and Conditions":
            if let url = URL(string: "https://leavecasa.com/terms-and-conditions") {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        case "Help & Support":
            if let url = URL(string: "https://leavecasa.com/help-and-support") {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        case "Cancellation Policy":
            if let url = URL(string: "https://leavecasa.com/cancellation-and-refund") {
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        case "Guest User":
            if let url = URL(string: urlString) {
                let urlRequest = URLRequest(url: url)
                lblHeader.text = "Invoice"
                webView.load(urlRequest)
            }
        case "E-ticket" :
            if let url = URL(string: type == 2 ? "\(baseUrl)/bus/e-ticket/\(bookingId)" : type == 1 ? "\(baseUrl)/flight/e-ticket/\(bookingId)" : "\(baseUrl)/hotel/e-ticket/\(bookingId)" ) {

                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        default:
            break
        }
    }
    //MARK: - @IBActions
    @IBAction func backPressed(_ sender: UIButton) {
        if isDetailScreen {
            self.popView()
        } else {
            if title == "E-ticket" || type == 4 {
                let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as! TabbarVC
                self.setView(vc: vc, animation: false)
            } else {
                self.popView()
            }
        }
    }
    @IBAction func actionDownload(_ sender: Any) {
        savePdf()
    }
    //MARK: - Custom Methods
    func savePdf() {
        let url = URL(string: "\(baseUrl)/flight/e-ticket/\(self.bookingId)")
        let pdfData = try? Data.init(contentsOf: url!)
        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        let pdfNameFromUrl = "LeaveCasa-MyFile.pdf"
        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
        do {
            try pdfData?.write(to: actualPath, options: .atomic)
            LoaderClass.shared.showSnackBar(message: "Pdf successfully saved!")
            //file is downloaded in app data container, I can find file from x code > devices > MyApp > download Container >This container has the file
        } catch {
            LoaderClass.shared.showSnackBar(message: ("Pdf could not be saved"))
        }
    }
}
