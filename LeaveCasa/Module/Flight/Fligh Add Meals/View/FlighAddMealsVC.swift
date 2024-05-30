//
//  FlighAddMealsVC.swift
//  LeaveCasa
//
//  Created by acme on 21/11/22.
//

import UIKit

class FlighAddMealsVC: UIViewController {
    
    @IBOutlet weak var mealCollection: UICollectionView!
    @IBOutlet weak var flightCollection: UICollectionView!
    
    var indexArray = [Int]()
    var ssrModel : SsrFlightModel?
    var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil

        self.setupCollectionView()
        
    }
    
    func setupCollectionView(){
        
        self.flightCollection.delegate = self
        self.flightCollection.dataSource = self
        self.flightCollection.ragisterNib(nibName: FlightXIB().identifire)
        
        self.mealCollection.delegate = self
        self.mealCollection.dataSource = self
        self.mealCollection.ragisterNib(nibName: FlighFoodXIB().identifire)
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popView()
    }
    
    @IBAction func skipOnPress(_ sender: UIButton) {
        
    }
    
    @IBAction func continueOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .SelectSeatVC, StoryboardName: .Flight) as? SelectSeatVC{
            vc.ssrModel = self.ssrModel
            self.pushView(vc: vc)
        }
    }
    
}

//MARK: UICollectionView Delegate

extension FlighAddMealsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ssrModel?.ssr?.response?.mealDynamic?.first?.count ?? self.ssrModel?.ssr?.response?.meal?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.mealCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlighFoodXIB().identifire, for: indexPath) as! FlighFoodXIB
            
            let indexData = self.ssrModel?.ssr?.response?.mealDynamic?.first?[indexPath.row]
            
            if self.selectedIndex == indexPath.row{
                cell.imgCheck.image = .checkMark()
            }else{
                cell.imgCheck.image = .uncheckMark()
            }
            
            cell.imgFood.image = .placeHolder()
            cell.lblPrice.text = "₹\(indexData?.price ?? 0)"
            cell.lblFoodName.text = "\(indexData?.airlineDescription ?? "No Food")"
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightXIB().identifire, for: indexPath) as! FlightXIB
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.mealCollection{
            return CGSize(width: (self.mealCollection.frame.size.width / 2) - 10, height: 180)
        }else{
            return CGSize(width: self.flightCollection.frame.size.width / 2, height: self.flightCollection.frame.size.height)
        }
    }
}
