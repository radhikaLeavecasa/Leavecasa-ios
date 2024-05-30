//
//  CalendarPopUpVC.swift
//  LeaveCasa
//
//  Created by acme on 11/03/24.
//

import UIKit
import  FSCalendar

class CalendarPopUpVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    //MARK: - @IBOutlets
    @IBOutlet weak var vwCalendar: FSCalendar!
    //MARK: - Variables
    var firstDate: Date?
    var lastDate: Date?
    private var datesRange: [Date]?
    typealias completion = (_ firstDate: String, _ lastDate: String) -> Void
    var doneCompletion: completion? = nil

    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        datesRange = datesRange(from: firstDate!, to: lastDate!)
        vwCalendar.allowsMultipleSelection = true
        vwCalendar.delegate = self
        vwCalendar.dataSource = self
        for d in datesRange ?? [] {
            vwCalendar.select(d)
        }
    }
    //MARK: - @IBActions
    @IBAction func actionCross(_ sender: Any) {
        dismiss()
    }
    @IBAction func actionOk(_ sender: Any) {
        if firstDate != nil && lastDate != nil {
            self.dismiss(animated: true) {
                guard let okButton = self.doneCompletion else { return }
                okButton(self.convertDate(self.firstDate ?? Date()), self.convertDate(self.lastDate ?? Date()))
            }
        }
    }
    //MARK: - Calendar methods
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]
            return
        }
        
        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]
                return
            }
            
            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last
            
            for d in range {
                calendar.select(d)
            }
            
            datesRange = range
         
            return
        }
        
        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
            
        }
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:
        
        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }
            
            lastDate = nil
            firstDate = nil
            
            datesRange = []
        }
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if (Calendar.current.date(byAdding: .day, value: 1, to: date)!.description.components(separatedBy: " ")[0]) < Date().description.components(separatedBy: " ")[0] { // Prevent selection of dates before current date
            return false
        }
        return true
    }
    func dateIsInRange(_ date: Date) -> Bool {
        // Define your range of selected dates here
        let startDate = self.firstDate ?? Date()// Your start date
        let endDate = self.lastDate ?? Date()// Your end date

        if date >= startDate && date <= endDate {
            return true
        } else {
            return false
        }
    }
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
}
//enum SelectionType {
//    case none
//    case today
//    case single
//    case leftBorder
//    case middle
//    case rightBorder
//}

//class RangePickerCell: FSCalendarCell {
//
//    private weak var circleImageView: UIImageView?
//    private weak var selectionLayer: CAShapeLayer?
//    private weak var roundedLayer: CAShapeLayer?
//    private weak var todayLayer: CAShapeLayer?
//
//    var selectionType: SelectionType = .none {
//        didSet {
//            setNeedsLayout()
//        }
//    }
//
//    required init!(coder aDecoder: NSCoder!) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    private func commonInit() {
//        let selectionLayer = CAShapeLayer()
//        selectionLayer.fillColor = UIColor.lightGray.cgColor
//        selectionLayer.actions = ["hidden": NSNull()]
//        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel?.layer)
//        self.selectionLayer = selectionLayer
//
//        let roundedLayer = CAShapeLayer()
//        roundedLayer.fillColor = UIColor.blue.cgColor
//        roundedLayer.actions = ["hidden": NSNull()]
//        self.contentView.layer.insertSublayer(roundedLayer, below: self.titleLabel?.layer)
//        self.roundedLayer = roundedLayer
//
//        let todayLayer = CAShapeLayer()
//        todayLayer.fillColor = UIColor.clear.cgColor
//        todayLayer.strokeColor = UIColor.orange.cgColor
//        todayLayer.actions = ["hidden": NSNull()]
//        self.contentView.layer.insertSublayer(todayLayer, below: self.titleLabel?.layer)
//        self.todayLayer = todayLayer
//
//        self.shapeLayer.isHidden = true
//        let view = UIView(frame: self.bounds)
//        self.backgroundView = view
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.selectionLayer?.frame = self.contentView.bounds
//        self.roundedLayer?.frame = self.contentView.bounds
//        self.todayLayer?.frame = self.contentView.bounds
//
//        let contentHeight = self.contentView.frame.height
//        let contentWidth = self.contentView.frame.width
//
//        let selectionLayerBounds = selectionLayer?.bounds ?? .zero
//        let selectionLayerWidth = selectionLayer?.bounds.width ?? .zero
//        let roundedLayerHeight = roundedLayer?.frame.height ?? .zero
//        let roundedLayerWidth = roundedLayer?.frame.width ?? .zero
//
//        switch selectionType {
//        case .middle:
//            self.selectionLayer?.isHidden = false
//            self.roundedLayer?.isHidden = true
//            self.todayLayer?.isHidden = true
//
//            let selectionRect = selectionLayerBounds
//                .insetBy(dx: 0.0, dy: 4.0)
//            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath
//
//        case .leftBorder:
//            self.selectionLayer?.isHidden = false
//            self.roundedLayer?.isHidden = false
//            self.todayLayer?.isHidden = true
//
//            let selectionRect = selectionLayerBounds
//                .insetBy(dx: selectionLayerWidth / 4, dy: 4)
//                .offsetBy(dx: selectionLayerWidth / 4, dy: 0.0)
//            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath
//
//            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
//            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
//                              y: contentHeight / 2 - diameter / 2,
//                              width: diameter,
//                              height: diameter)
//                .insetBy(dx: 2.5, dy: 2.5)
//            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath
//
//        case .rightBorder:
//            self.selectionLayer?.isHidden = false
//            self.roundedLayer?.isHidden = false
//            self.todayLayer?.isHidden = true
//
//            let selectionRect = selectionLayerBounds
//                .insetBy(dx: selectionLayerWidth / 4, dy: 4)
//                .offsetBy(dx: -selectionLayerWidth / 4, dy: 0.0)
//            self.selectionLayer?.path = UIBezierPath(rect: selectionRect).cgPath
//
//            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
//            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
//                              y: contentHeight / 2 - diameter / 2,
//                              width: diameter,
//                              height: diameter)
//                .insetBy(dx: 2.5, dy: 2.5)
//            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath
//
//        case .single:
//            self.selectionLayer?.isHidden = true
//            self.roundedLayer?.isHidden = false
//            self.todayLayer?.isHidden = true
//
//            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
//            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
//                              y: contentHeight / 2 - diameter / 2,
//                              width: diameter,
//                              height: diameter)
//                .insetBy(dx: 2.5, dy: 2.5)
//            self.roundedLayer?.path = UIBezierPath(ovalIn: rect).cgPath
//
//        case .today:
//            self.selectionLayer?.isHidden = true
//            self.roundedLayer?.isHidden = true
//            self.todayLayer?.isHidden = false
//
//            let diameter: CGFloat = min(roundedLayerHeight, roundedLayerWidth)
//            let rect = CGRect(x: contentWidth / 2 - diameter / 2,
//                              y: contentHeight / 2 - diameter / 2,
//                              width: diameter,
//                              height: diameter)
//                .insetBy(dx: 2.5, dy: 2.5)
//            self.todayLayer?.path = UIBezierPath(ovalIn: rect).cgPath
//
//        case .none:
//            self.selectionLayer?.isHidden = true
//            self.roundedLayer?.isHidden = true
//            self.todayLayer?.isHidden = true
//        }
//    }
//}
