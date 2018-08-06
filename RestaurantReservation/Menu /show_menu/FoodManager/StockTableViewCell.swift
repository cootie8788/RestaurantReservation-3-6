

import UIKit


class StockTableViewCell: UITableViewCell ,popViewControllerDelegate{
    
    
    func getUIbBt_change_stockutton(_ num: Int) {
        menu_stock.setTitle("\(num)", for: .normal)
    }
    

    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var menu_name: UILabel!

    @IBOutlet weak var menu_stock: UIButton!
    
    var controler : StockMenuTableViewController?
//    weak var delegate : StockTableViewCellDelegate?
    
    @IBAction func changeStockBt(_ sender: UIButton) {

        guard let controler = controler else{
            return
        }
        
        guard let pop =
            controler.storyboard?.instantiateViewController(withIdentifier: "popview") as? popViewController else{
                return
        }
    
        pop.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        pop.modalPresentationStyle = .overCurrentContext //必須覆蓋過去
        
        pop.menu_id = self.tag
        pop.delegate = self
        
        controler.present(pop, animated: true)
        
        
//        delegate?.getUIbutton(bt: menu_stock)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
