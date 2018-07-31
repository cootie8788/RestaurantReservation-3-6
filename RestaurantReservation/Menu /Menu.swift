

import Foundation

struct Menu: Codable{
    var id : Int = -1
    var name : String = ""
    var price : String = ""
    var type : Int = -1
    var note : String = ""
    var stock : Int = -1
}

struct OrderMenu: Codable{
    var id : Int = -1
    var name : String = ""
    var price : String = ""
    var type : Int = -1
    var note : String = ""
    var stock : Int = -1
    var quantity : Int = -1
}

struct Coupon :Codable{
    var coupon :String
    var discount :Double
}

struct respone_orderId :Codable {
    var orderId:String = ""
}

enum Parameters : String {
    case getAll
    case menuInsert
    case menuUpdata
    case menuDelete
    case menuUpdata_stock
    case getImage
}

