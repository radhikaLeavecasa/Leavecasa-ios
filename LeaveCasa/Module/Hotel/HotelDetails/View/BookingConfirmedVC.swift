//
//  BookingConfirmedVC.swift
//  LeaveCasa
//
//  Created by acme on 24/08/23.
//

import UIKit

class BookingConfirmedVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblBookingConfirmed: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBookingConfimed: UIButton!
    @IBOutlet weak var imgVwBooking: UIImageView!
    //MARK: - Variables
    typealias completion = (_ title: String) -> Void
    var doneCompletion: completion? = nil
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch title {
        case "hotel":
            lblTitle.text = "Hotel Room Reserved!"
            lblBookingConfirmed.text = "Booking confirmed. Get ready to relax and enjoy your stay!"
        case "bus":
            lblTitle.text = "Bus Seat Reserved!"
            lblBookingConfirmed.text = "Booking confirmed. Enjoy your trip!"
        case "flightReturn":
            lblTitle.text = "One Way Flight Ticket Booked!"
            lblBookingConfirmed.text = "Booking confirmed for one way. Continue for return flight."
        case "flight":
            lblTitle.text = "Flight Ticket Booked!"
            lblBookingConfirmed.text = "Booking confirmed. Enjoy your trip!"
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            LoaderClass.shared.setupGIF(self.title == "hotel" ? "Hotel" : self.title == "bus" ? "Bus" : "Airplane", imgVW: self.imgVwBooking)
        }
    }
    //MARK: - @IBActions
    @IBAction func actionBookingConfirmed(_ sender: Any) {
        self.dismiss(animated: true) {
            guard let doneButton = self.doneCompletion else { return }
            doneButton(self.title ?? "")
            self.imgVwBooking.stopAnimating()
        }
    }
}

extension UIImageView {
    static func fromGif(frame: CGRect, resourceName: String) -> UIImageView? {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else {
            print("Gif does not exist at that path")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for i in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        let gifImageView = UIImageView(frame: frame)
        gifImageView.animationImages = images
        return gifImageView
    }
}
