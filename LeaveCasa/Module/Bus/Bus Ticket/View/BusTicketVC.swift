//
//  BusTicketVC.swift
//  LeaveCasa
//
//  Created by acme on 28/10/22.
//

import UIKit
import PDFGenerator
import SafariServices

class BusTicketVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblSeatNumber: UILabel!
    @IBOutlet weak var lblToTime: UILabel!
    @IBOutlet weak var lblFromTime: UILabel!
    @IBOutlet weak var lblToName: UILabel!
    @IBOutlet weak var lblfromName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblBusName: UILabel!
    @IBOutlet weak var lblBusNumber: UILabel!
    @IBOutlet weak var lblPnrNumber: UILabel!
    //MARK: - Variables
    fileprivate var outputAsData: Bool = false
    
    //MARK: - @IBActions
    @IBAction func backToHomeOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .TabbarVC, StoryboardName: .Main) as? TabbarVC{
            self.pushView(vc: vc)
        }
    }
    
    @IBAction func needHelpOnPress(_ sender: UIButton) {
    }
    
    @IBAction func showDetailsOnPress(_ sender: UIButton) {
        if let vc = ViewControllerHelper.getViewController(ofType: .BusTicketDetailsVC, StoryboardName: .Bus) as? BusTicketDetailsVC{
            self.pushView(vc: vc)
        }
    }
    
    fileprivate func getDestinationPath(_ number: Int) -> String {
        return NSHomeDirectory() + "/sample\(number).pdf"
    }
    
    @IBAction func shareOnPress(_ sender: UIButton) {
        
        // image to share
        let image = self.mainView.takeScreenshot()
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}
