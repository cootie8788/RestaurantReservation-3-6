

import UIKit

protocol OrderMenuTableViewCellDelegate: class {
    //回傳 tuple 可以用數字0 1取值 也可以命名
    func getSomething(_ cell:UITableViewCell) -> (id:Int,
                                                  name:String,
                                                  price:String,
                                                  stock:Int,
                                                  type:Int)?
    func jim() -> (name:Int , jim:String)
//    func getFoodInfo(_ cell:UITableViewCell) -> [String: Any]
    
    //可以讓 任意control 實作我需要的參數 與 方法
    //達到 資料交換 取用table 函數的目的
    
    //也可以帶入cell來用
    //func get(_ cell:UITableViewCell) -> (String,int)  ...多個參數
}

class OrderMenuTableViewCell: UITableViewCell {
    //cell 可以在載入所有cell時 將control 傳給所以cell的變數 cell是拿得到controler
    
    //控制器要拿到所選擇的cell 可以在設置protocol
    weak var delegate: OrderMenuTableViewCellDelegate?
    //可以使用   static weak var delegate: OrderMenuTableViewCellDelegate?
    
    let app = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var orderMenu_cell_Image: UIImageView!
    @IBOutlet weak var orderMenu_cell_item: UILabel!
    @IBOutlet weak var orderMenu_cell_money: UILabel!
    @IBOutlet weak var orderMenu_cell_num: UILabel!
    
    var ctrler : UITableViewController?
    
    var menu_count : UILabel?
    var money_total : UILabel?

    var cellID = 0  //array 對應內容的id
    var cellName = ""
    var cellPrice = ""
    var cellStock = 0
    var type = 0
    
    @IBAction func remove(_ sender: UIButton) {
        
//        var tryy = delegate?.jim()
        
        
//        let index = self.tag
        
//        guard let something = delegate?.getSomething(self) else {
//            assertionFailure("get nil ")
//            return  }
        
//        let id = something.0
        let id = cellID
        
        if self.backgroundColor == .red {
            self.backgroundColor = .white
        }
        
        guard var findOederMenu = app.cart[id] else {
            print("not finded")
            return  }
        
        if findOederMenu.quantity == 1 { //1 減掉一 就移除
            
            orderMenu_cell_num.text = "\(0)"
            
            app.cart.removeValue(forKey: id)
            
            if let ctrler = ctrler{  //如果有給控制器就支援 歸0刪除功能
                
                guard let indexPath = ctrler.tableView.indexPath(for: self) else{
                    assertionFailure("find indexPath Fail")
                    return
                }
                ctrler.tableView.deleteRows(at: [indexPath], with: .left)
            }
            //            print("\n\(app.cart)\n")
            reflushLabel()
            return
        }
        
        if findOederMenu.quantity > 0 {
            
            findOederMenu.quantity -= 1
            orderMenu_cell_num.text = "\(findOederMenu.quantity)"
            
            app.cart[id] = findOederMenu
            //            print("\n\(app.cart)\n")
            
        }//if
        
        reflushLabel()
    }//remove(_ sender: UIButton)
    
   
    
    @IBAction func add(_ sender: UIButton) {


//        let index = self.tag   //array index
    
//        guard let something = delegate?.getSomething(self) else {
//            assertionFailure("get nil ")
//            return  }
        
//        let id = something.id
//        let name = something.name
//        let price = something.price
//        let stock = something.stock
//        let type = something.type
        
        let id = cellID
        let name = cellName
        let price = cellPrice
        let stock = cellStock
        
        if var findOederMenu = app.cart[id] { //有找到
            
            if findOederMenu.quantity < 9 && stock > findOederMenu.quantity {
                
                findOederMenu.quantity += 1
                orderMenu_cell_num.text = "\(findOederMenu.quantity)"
                
                app.cart[id] = findOederMenu  //更新內容
//                print("\(app.cart)\n")
                
            }else{// 超出限制 變色
                backgroundColor = .red
                return
            }
            
        }else{
            // 產生一個 實體並 quantity +1
            orderMenu_cell_num.text = "\(1)"
            var struc = OrderMenu(id: id, name: name, price: price, type: type, note: "", stock: stock, quantity: 1)
            app.cart[id] = struc
            print("\n\(app.cart)\n")
        }
        
        reflushLabel()
    }//add(_ sender: UIButton)
    
    
    func reflushLabel()  {
        var total = 0
        
        guard let menu_count = menu_count else {
            return  }
        
        guard let money_total = money_total else {
            return  }
        
        for (_ ,value) in app.cart {
            
            total += (value.quantity * (Int(value.price) ?? 0))
        }
        menu_count.text = "\(app.cart.count)"
        money_total.text = "$\(total)"
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
// 可以丟button 找button上的cell
//    func findCellByUIview(_ UIview:UIView) -> OrderMenuTableViewCell? {
//        var view = UIview
//        var i = 0
//
//        while view.superview != nil {
//            view = view.superview!
//
//            if view is UITableViewCell{
//                //                print("find")
//                return view as! OrderMenuTableViewCell
//            }
//            i+=1
//            //            print("\(i)")
//        }
//        return nil
//    }
    
    
//    func findCellNumByUIview(_ UIview:UIView) -> Int {
//        var view = UIview
//        var i = 0
//
//        while view.superview != nil {
//            view = view.superview!
//
//            if view is UITableView{
//                print("find")
//                break
//            }
//            i+=1
//            print("\(i)")
//        }
//
//        let tableView = view as! UITableView
//
//        if let num_row = tableView.indexPath(for: self)?.row {
//            //            print("\(num_row)")
//            return num_row
//        }
//        return -1
//    }
}
