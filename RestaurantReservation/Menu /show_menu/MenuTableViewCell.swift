

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellitem: UILabel!
    @IBOutlet weak var cellmoney: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
