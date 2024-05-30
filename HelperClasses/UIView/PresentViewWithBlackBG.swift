//
//  PresentViewWithBlackBG.swift
//  LeaveCasa
//
//  Created by acme on 19/10/22.
//

import UIKit

class PresentationController: UIPresentationController {

  let blurEffectView: UIVisualEffectView!
  var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
  
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
      let blurEffect = UIBlurEffect(style: .dark)
      blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.backgroundColor = .black
      super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
      tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissController))
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.blurEffectView.isUserInteractionEnabled = true
      self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  override var frameOfPresentedViewInContainerView: CGRect {
      CGRect(origin: CGPoint(x: 0, y: self.containerView!.frame.height * 0.4),
             size: CGSize(width: self.containerView!.frame.width, height: self.containerView!.frame.height *
              0.6))
  }

  override func presentationTransitionWillBegin() {
      self.blurEffectView.alpha = 0
      self.containerView?.addSubview(blurEffectView)
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0.5
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in })
  }
  
  override func dismissalTransitionWillBegin() {
      self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.alpha = 0
      }, completion: { (UIViewControllerTransitionCoordinatorContext) in
          self.blurEffectView.removeFromSuperview()
      })
  }
  
  override func containerViewWillLayoutSubviews() {
      super.containerViewWillLayoutSubviews()
    presentedView!.roundCorners([.topLeft, .topRight], radius: 22)
  }

  override func containerViewDidLayoutSubviews() {
      super.containerViewDidLayoutSubviews()
      presentedView?.frame = frameOfPresentedViewInContainerView
      blurEffectView.frame = containerView!.bounds
  }

  @objc func dismissController(){
      self.presentedViewController.dismiss(animated: true, completion: nil)
  }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0.0
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 0.5
        rotation.isCumulative = true
        rotation.repeatCount = 0.5
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func takeScreenshot() -> UIImage {
      
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
       
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
       
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil) {
            return image!
        }
        return UIImage()
    }
}

class HSUnderLineTextField: UITextField, UITextFieldDelegate {
    
    let border = CALayer()
    
    @IBInspectable open var lineColor: UIColor = UIColor.black {
        didSet {
            border.borderColor = lineColor.cgColor
        }
    }
    
    @IBInspectable open var selectedLineColor: UIColor = UIColor.black {
        didSet {
        }
    }
    
    @IBInspectable open var lineHeight: CGFloat = CGFloat(1.0) {
        didSet {
            border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width: self.frame.size.width, height: self.frame.size.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        border.borderColor = lineColor.cgColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = lineHeight
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        border.frame = CGRect(x: 0, y: self.frame.size.height - lineHeight, width: self.frame.size.width, height: self.frame.size.height)
        self.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.borderColor = selectedLineColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        border.borderColor = lineColor.cgColor
    }
}
