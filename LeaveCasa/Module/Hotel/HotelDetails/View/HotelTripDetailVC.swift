//
//  HotelTripDetailVC.swift
//  LeaveCasa
//
//  Created by acme on 21/09/23.
//

import UIKit
import AdvancedPageControl
import IBAnimatable
import SDWebImage

class HotelTripDetailVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblHotelDescp: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblBookingPrice: UILabel!
    @IBOutlet weak var lblNamePassenger: UILabel!
    @IBOutlet weak var lblCheckOut: UILabel!
    @IBOutlet weak var lblCheckIn: UILabel!
    @IBOutlet weak var lblHotelCity: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var vwPageControl: AdvancedPageControlView!
    @IBOutlet weak var btnInvoice: AnimatableButton!
    @IBOutlet weak var lblNumberOfRooms: UILabel!
    @IBOutlet weak var vwCancellation: UIView!
    @IBOutlet weak var collVwImages: UICollectionView!
    //MARK: - Variables
    var imagesUrl = [URL]()
    typealias completion = (_ tag: Int) -> Void
    var doneCompletion: completion? = nil
    var hotelDetail: TripHotel?
    var viewModel = TripViewModel()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        let currentDate = convertDate(Date())
        vwCancellation.isHidden = hotelDetail?.booking_status == Strings.CONFIRMED && hotelDetail?.from_date ?? "" > currentDate
        self.setUpData()
        self.setupCollectionView()
        self.vwPageControl.numberOfPages = self.hotelDetail?.hotelImages?.count ?? 0
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 20, width: 200, height: 30)
        let attributedString = NSMutableAttributedString.init(string: AlertMessages.CANCELLATION_POLICY)
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 2, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        //MARK: Setup PageIndicater
        self.vwPageControl.drawer = ScaleDrawer(numberOfPages: self.hotelDetail?.hotelImages?.count, height: 10, width: 10, space: 10, raduis: 10, currentItem: 0, indicatorColor: .white, dotsColor: .clear, isBordered: true, borderColor: .white, borderWidth: 1.0, indicatorBorderColor: .white, indicatorBorderWidth: 1.0)
        
        DispatchQueue.main.async {
            self.imagesUrl.removeAll()
            for index in self.hotelDetail?.hotelImages ?? [] {
                if let url = URL(string: "https://images.grnconnect.com/\(index.image_url ?? "")") {
                    self.imagesUrl.append(url)
                }
            }
            self.collVwImages.reloadData()
        }
    }
    //MARK: - @IBActions
    @IBAction func actionBack(_ sender: Any) {
        self.popView()
    }
    
    @IBAction func actionCancelInvoice(_ sender: UIButton) {
        if sender.tag == 0 {
            if let vc = ViewControllerHelper.getViewController(ofType: .CommonPopupVC, StoryboardName: .Main) as? CommonPopupVC {
                vc.modalPresentationStyle = .overFullScreen
                vc.modalTransitionStyle = .crossDissolve
                vc.isNoHide = true
                vc.titleStr = "Are you sure you want to cancel booking?"
                vc.msg = AlertMessages.CANCELLATION_ALERT
                vc.noTitle = AlertKeys.NO
                vc.yesTitle = AlertKeys.YES
                vc.tapCallback = {
                    self.viewModel.callCancelHotelBooking(bookingId: self.hotelDetail?.booking_id ?? "", view: self)
                    self.popView()
                }
                self.present(vc, animated: true)
            }
        } else {
            if let vc = ViewControllerHelper.getViewController(ofType: .TripDetailsVC, StoryboardName: .Main) as? TripDetailsVC {
                vc.bookingId = "\(self.hotelDetail?.id ?? 0)"
                vc.type = 1
                self.pushView(vc: vc,title: AlertMessages.INVOICE)
            }
        }
    }
    //MARK: - Custom methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collVwImages {
            
            let offSet = scrollView.contentOffset.x
            let width = scrollView.frame.width
            
            let index = Int(round(offSet/width))
            print(index)
            self.vwPageControl.setPage(index)
            
        }
    }
    func setupCollectionView(){
        self.collVwImages.delegate = self
        self.collVwImages.dataSource = self
        self.collVwImages.ragisterNib(nibName: HotelImagesXIB().identifire)
       // self.scrollView.delegate = self
    }
    
    //MARK: - Custom methods
    func setUpData(){
        lblNumberOfRooms.text = "\(hotelDetail?.tripHotel?.booking_items?[0].rooms?[0].description ?? "") x \(hotelDetail?.tripHotel?.booking_items?[0].rooms?[0].no_of_rooms ?? 1)"
        lblHotelName.text = hotelDetail?.tripHotel?.name
        lblHotelCity.text = "In \(hotelDetail?.tripHotel?.city_name ?? "")"
        lblCheckIn.text = convertDateFormat(date: hotelDetail?.from_date ?? "", getFormat: DateFormat.dayDateMonthYear, dateFormat: DateFormat.yearMonthDate)
        lblCheckOut.text = convertDateFormat(date: hotelDetail?.to_date ?? "", getFormat: DateFormat.dayDateMonthYear, dateFormat: DateFormat.yearMonthDate)
        lblHotelDescp.text = hotelDetail?.tripHotel?.description
        lblRating.text = "\(hotelDetail?.tripHotel?.category ?? 0).0/5"
        lblNamePassenger.text = "\(hotelDetail?.tripHotel?.paxes?[0].name ?? "") \(hotelDetail?.tripHotel?.paxes?[0].surname ?? "")"
        lblBookingPrice.text = "₹ \(hotelDetail?.tripHotel?.booking_items?[0].price ?? 0)"
    }
}

extension HotelTripDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.hotelDetail?.hotelImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotelImagesXIB().identifire, for: indexPath) as! HotelImagesXIB
        let dict = self.hotelDetail?.hotelImages?[indexPath.row]
        
        cell.imgHotel.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgHotel.sd_setImage(with: URL(string: "https://images.grnconnect.com/\(dict?.image_url ?? "")"), placeholderImage: .hotelplaceHolder())
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collVwImages.frame.size.width, height: (self.collVwImages.frame.size.height))
    }
}
