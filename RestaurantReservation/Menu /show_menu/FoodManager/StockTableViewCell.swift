

import UIKit


class StockTableViewCell: UITableViewCell ,popViewControllerDelegate ,StockMenuPickDelegate{
    
    func displayBtNum(_ num: Int) {
        menu_stock.setTitle("\(num)", for: .normal)
    }
    
    func getUIbBt_change_stockutton(_ num: Int) {
        menu_stock.setTitle("\(num)", for: .normal)
    }

    @IBOutlet weak var FoodImage: UIImageView!
    @IBOutlet weak var menu_name: UILabel!
    @IBOutlet weak var menu_stock: UIButton!
    
    var pickview : UIPickerView?
    var tableHight : CGFloat = 0
    
    var controler : StockMenuTableViewController?
    
    
    @IBAction func changeStockBt(_ sender: UIButton) {
        
//        controler?.delegate = self
        
        
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
        
    }
 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        controler?.delegate = self
        
        // Configure the view for the selected state
    }

}
