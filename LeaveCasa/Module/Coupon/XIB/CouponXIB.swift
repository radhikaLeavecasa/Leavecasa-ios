import UIKit

class CouponXIB: UITableViewCell {

    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var lblCouponName: UILabel!
    @IBOutlet weak var lblCouponDescription: UILabel!
    @IBOutlet weak var lblCouponPrice: UILabel!
    
    let identifire = "CouponXIB"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
