//
//  NotificationVC.swift
//  LeaveCasa
//
//  Created by acme on 27/09/22.
//

import UIKit

class NotificationVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var btnBackTrailing: NSLayoutConstraint!
    @IBOutlet weak var btnBackWidth: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableVIew: UITableView!
    //MARK: - Variables
    var isFromSetting = false
    var viewModel = NotificationViewModel()
    let refreshControl = UIRefreshControl()
    var objHomeViewModel = HomeViewModel()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false {
           // self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
            self.viewModel.delegate = self
            LoaderClass.shared.loadAnimation()
            self.objHomeViewModel.callHomeCoupons(view: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "isGuestUser") as? Bool == false {
            self.viewModel.getNotification(view: self)
        }
    }
    //MARK: - Custom methods
    func setupTableView(){
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        self.tableVIew.ragisterNib(nibName: NotificationXIB().identifire)
        self.tableVIew.ragisterNib(nibName: OfferCouponNotificationXIB().identifire)
        self.tableVIew.ragisterNib(nibName: NoDataFoundXIB().identifire)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableVIew.addSubview(refreshControl) 
        
        if self.isFromSetting == true{
            self.btnBack.isHidden = false
            self.btnBackWidth.constant = 40
            self.btnBackTrailing.constant = 20
        }else{
            self.btnBack.isHidden = true
            self.btnBackWidth.constant = 0
            self.btnBackTrailing.constant = 0
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.getNotification(view: self)
    }
}

extension NotificationVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.modelData?.data?.count ?? 0 == 0 || WebService.isConnectedToInternet() == false {
            return 1
        }else{
            return (self.viewModel.modelData?.data?.count ?? 0) + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.modelData?.data?.count ?? 0 == 0 || WebService.isConnectedToInternet() == false {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: NoDataFoundXIB().identifire, for: indexPath) as! NoDataFoundXIB
            if WebService.isConnectedToInternet() == false {
                cell.img.image = .internetConnection()
                cell.lblTitleMsg.text = AlertMessages.NOT_CONNECTED_TO_INTERNET
                cell.lblMsg.text = AlertMessages.DISCONNECTED
                cell.lblSubTitleMsg.text = ""
            } else {
                cell.cnstImgVwTop.constant = 150
                cell.img.image = UIImage(named: "ic_no_notification")
                cell.imgVwNoData.constant = 200
                cell.lblTitleMsg.text = ""
                cell.lblMsg.text = AlertMessages.NO_NOTIFICATION_FOUND
                cell.lblSubTitleMsg.text = ""
            }
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: OfferCouponNotificationXIB().identifire, for: indexPath) as! OfferCouponNotificationXIB

                cell.imgVwOffer.sd_setImage(with: URL(string: objHomeViewModel.couponData?[(objHomeViewModel.couponData?.count ?? 0)-1].imgUrl ?? ""), placeholderImage: .placeHolder())
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NotificationXIB().identifire, for: indexPath) as! NotificationXIB
                let indexData = self.viewModel.modelData?.data?[indexPath.row-1]
                cell.lblDate.text = indexData?.created_at?.convertDateWithString() ?? ""
                cell.lblTitle.text = indexData?.subject ?? ""
                cell.lblSubTitle.text = indexData?.content ?? ""
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.modelData?.data?.count ?? 0 == 0 ? tableView.frame.size.height : UITableView.automaticDimension
    }
}

extension NotificationVC:ResponseProtocol{
    
    func onSuccess() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.setupTableView()
            self.tableVIew.reloadData()
        }
    }
    
    func onFail(msg: String) {
        DispatchQueue.main.async {
            self.setupTableView()
            self.refreshControl.endRefreshing()
            self.tableVIew.reloadData()
        }
    }
}
