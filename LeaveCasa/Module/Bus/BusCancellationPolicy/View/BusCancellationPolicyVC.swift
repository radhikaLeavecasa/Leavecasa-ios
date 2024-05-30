import UIKit

class BusCancellationPolicyVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    //MARK: - Variables
    lazy var bus = Bus()
    var busDetail: TripBus?
    var policies = [String]()
    var deductions = [String]()
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.addObserver(self, forKeyPath: Strings.CONTENT_SIZE, options: .new, context: nil)
        displayData()
    }
    //MARK: Add Observer For Tableview Height
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Strings.CONTENT_SIZE {
            if let newvalue = change?[.newKey] {
                if let newsize = newvalue as? CGSize {
                    DispatchQueue.main.async {
                        self.tableViewHeightConstraint.constant = newsize.height
                    }
                }
            }
        }
    }
    //MARK: - @IBActions
    @IBAction func backClicked(_ sender: UIButton) {
        self.dismiss()
    }
   
    //MARK: - Custom methods
    func displayData() {
        if bus.cancellationPolicy.components(separatedBy: ";").count > 0 {
            let cancellationPolicy = bus.sBusId != "" ? bus.cancellationPolicy.components(separatedBy: ";") : busDetail?.bus_details?.cancellationPolicy?.components(separatedBy: ";")
            let newTimeStamp = bus.sBusId != "" ? "\(bus.cancellationCalculationTimestamp.replacingOccurrences(of: " IST", with: ""))" : "\(busDetail?.bus_details?.cancellationCalculationTimestamp?.replacingOccurrences(of: " IST", with: "") ?? "")"
            
            for policy in cancellationPolicy ?? [] {
                if policy.components(separatedBy: ":").count >= 3 {
                    let startTime = policy.components(separatedBy: ":")[0]
                    let endTime = policy.components(separatedBy: ":")[1]
                    let deductionPer = "\(policy.components(separatedBy: ":")[2])%"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E MMM dd HH:mm:ss yyyy"
                    let time = dateFormatter.date(from: newTimeStamp)
                    
                    let startDate = Calendar.current.date(byAdding: .hour, value: -(Int(startTime) ?? 0), to: time ?? Date())
                    let endDate = Calendar.current.date(byAdding: .hour, value: -(Int(endTime) ?? 0), to: time ?? Date())
                    
                    dateFormatter.dateFormat = "dd MMM HH:mm"
                    let dateFrom = dateFormatter.string(from: endDate ?? Date())
                    let dateTo = dateFormatter.string(from: startDate ?? Date())
                                        
                    if startTime == "0" {
                        policies.append("After \(dateFrom)")
                        deductions.append(deductionPer)
                    }
                    else if endTime == "-1" {
                        policies.append("Before \(dateTo)")
                        deductions.append(deductionPer)
                    }
                    else {
                        policies.append("After \(dateFrom) & Before \(dateTo)")
                        deductions.append(deductionPer)
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        else {
            Alert.showSimple("Don't have cancellation policy for this Bus.")
        }
    }
}

// MARK: - UITABLEVIEW METHODS
extension BusCancellationPolicyVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return policies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusCancellationCell") as! MyCustomCell
        
        cell.lblTitle?.text = policies[indexPath.row]
        cell.lblPrice?.text = deductions[indexPath.row]
        //cell.detailTextLabel?.sizeToFit()
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

// Subclass of UITableViewCell to manage detailTextLabel
class MyCustomCell: UITableViewCell {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    //MARK: - Lifecycle methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let detail = self.detailTextLabel {
            // this will do the actual layout of the detail
            // label's text, so you can get its width
            detail.sizeToFit()
            
            // you might want to find a clever way to calculate this
            // instead of assigning a literal
            let rightMargin: CGFloat = 15
            
            // adjust the detail's frame
            let detailWidth = rightMargin + detail.frame.size.width
            detail.frame.origin.x = self.frame.size.width - detailWidth
            detail.frame.size.width = detailWidth
            detail.textAlignment = .left
            
            // now truncate the title label
            if let text = self.textLabel {
                if text.frame.origin.x + text.frame.size.width > self.frame.width - detailWidth {
                    text.frame.size.width = self.frame.width - detailWidth - text.frame.origin.x - rightMargin
                }
            }
        }
    }
}
