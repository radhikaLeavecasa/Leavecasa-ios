//
//  FlightBaggageVC.swift
//  LeaveCasa
//
//  Created by acme on 21/11/22.
//

import UIKit
import IBAnimatable

class FlightBaggageVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var priceBottomView: UIView!

    @IBOutlet weak var flightCollection: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var returnView: AnimatableView!
    @IBOutlet weak var onwordView: AnimatableView!
    @IBOutlet weak var btnReturn: UIButton!
    @IBOutlet weak var btnOnword: UIButton!
    //MARK: - Variables
    var selectedIndex : Int?
    var selectedFlightIndex : Int?
    var ssrModel : SsrFlightModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

        self.setupTableview()
        self.setupCollectionView()
    }

    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }

    func setupCollectionView(){

        self.flightCollection.delegate = self
        self.flightCollection.dataSource = self
        self.flightCollection.ragisterNib(nibName: FlightXIB().identifire)

    }

    func setupTableview(){
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.ragisterNib(nibName: BaggageXIB().identifire)
    }

    @IBAction func breakUpOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .FareBrakeupVC, StoryboardName: .Flight) as? FareBrakeupVC{
            self.present(vc, animated: true)
        }
    }

    @IBAction func onwordOnPress(_ sender: UIButton) {
        self.setupOnword()
    }

    @IBAction func returnOnPress(_ sender: UIButton) {
        self.setupReturn()
    }

    func setupOnword(){
        self.onwordView.backgroundColor = .cutomRedColor()
        self.returnView.backgroundColor = .clear
        self.btnOnword.setTitleColor(.white, for: .normal)
        self.btnReturn.setTitleColor(.theamColor(), for: .normal)

        self.tableView.reloadData()
    }

    func setupReturn(){
        self.returnView.backgroundColor = .cutomRedColor()
        self.onwordView.backgroundColor = .clear
        self.btnReturn.setTitleColor(.white, for: .normal)
        self.btnOnword.setTitleColor(.theamColor(), for: .normal)

        self.tableView.reloadData()
    }

}

//MARK: UITableview Delegate

extension FlightBaggageVC:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ssrModel?.ssr?.response?.baggage?.first?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaggageXIB().identifire, for: indexPath) as! BaggageXIB

        let indexData = self.ssrModel?.ssr?.response?.baggage?.first?[indexPath.row]

        cell.lblPRice.text = "₹\(indexData?.price ?? 0)"
        cell.lblWaight.text = "\(indexData?.weight ?? 0) KG"

        if self.selectedIndex == indexPath.row{
            cell.imgCheck.image = .checkMark()
            cell.backView.backgroundColor = .white
        }else{
            cell.imgCheck.image = .uncheckMark()
            cell.backView.backgroundColor = .white.withAlphaComponent(0.5)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
    }

}

//MARK: UICollectionView Delegate

extension FlightBaggageVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightXIB().identifire, for: indexPath) as! FlightXIB
        if self.selectedFlightIndex == indexPath.item{
            cell.backView.borderWidth = 1
            cell.backView.borderColor = .customBlueColor()
        }else{
            cell.backView.borderWidth = 0
            cell.backView.borderColor = .clear
        }

        return cell

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.flightCollection.frame.size.width / 2, height: self.flightCollection.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedFlightIndex = indexPath.item
        self.flightCollection.reloadData()
    }

}
