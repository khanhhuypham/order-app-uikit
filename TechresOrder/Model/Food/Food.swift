//
//  Food.swift
//  TechresOrder
//
//  Created by Kelvin on 16/01/2023.
//

import UIKit
import ObjectMapper



struct FoodResponse: Mappable {
    var total_record = 0
    var limit = 0
    var foods = [Food]()
    
 
    init?(map: Map) {
    }
    init?() {
    }
    
    mutating func mapping(map: Map) {
        total_record    <- map["total_record"]
        limit          <- map["limit"]
        foods          <- map["list"]
       
    }
}




struct Food:Mappable {
 
    var id = 0
    var description = ""
    var status = 0
    var name =  ""

    var note = ""
    var cancel_reason = ""
    var prefix = ""
    var price =  0
    var price_with_temporary:Int = 0
    var unit_type = ""
    var quantity:Float = 0
    var printed_quantity:Float = 0

    var category_id = 0
    var avatar = ""
    var avatar_thump = ""
    var normalize_name = ""

    var temporary_price = 0
    var temporary_percent = 0
    var temporary_price_from_date = ""
    var temporary_price_to_date = ""

    var is_addition = 0
    var is_addition_like_food = 0
    var is_sell_by_weight:Int = DEACTIVE

    var is_allow_print = 0
    var is_allow_print_stamp = 0
    var is_take_away = 0

    var category_type:FOOD_CATEGORY = .food

    var restaurant_vat_config_id =  0
    var food_in_combo = [FoodAddition]()
    var addition_foods = [FoodAddition]()
    var food_options = [FoodOptional]()
    var food_list_in_promotion_buy_one_get_one = [FoodAddition]()
    
    //================================================================================================================================================================
    var order_detail_additions:[OrderDetailAddition] = [] //Biến này chỉ dùng để map các món con khi gọi api lấy danh sách các món cần in
    var order_detail_options:[OptionOfDetailItem] = [] //Biến này chỉ dùng để map các món con khi gọi api lấy danh sách các món cần in
    var total_price_include_addition_foods:Int = 0
    var food_unit = ""
    //================================================================================================================================================================
    
    
    var restaurant_kitchen_place_id = 0
   
    var is_out_stock = 0
    var is_selected = 0
    var return_quantity_for_drink = 0
    var enable_return_beer = 0
    //temp
    var order_id = 0
    var discount_percent = 0
    var buffet_ticket_ids:[Int]? = nil
    
    // these variables use for local
    var TSCPrinter_id = 0
    var adjustPrice:Bool = false
    
    init() {}
    init?(map: Map) {
    }
    
    init(id:Int,name:String){
        self.id = id
        self.name = name
    }
    
    
    init(itemObject:ItemObject){
        self.id = itemObject.id
        self.name = itemObject.name
        self.quantity = itemObject.quantity
        self.is_sell_by_weight = itemObject.is_sell_by_weight
        self.note = itemObject.note
        
 
        var childrenItem:[FoodAddition] = []

        for child in itemObject.addition_foods{
            childrenItem.append(FoodAddition.init(name: child.name, quantity: child.quantity))
        }
        self.addition_foods = childrenItem
    }
    
    init(id:Int,name:String,quantity:Float,price:Int,note:String,restaurant_kitchen_place_id:Int){
        /*init for print test function*/
        self.id = id
        self.name = name
        self.quantity = quantity
        self.total_price_include_addition_foods = price
        self.note = note
        self.restaurant_kitchen_place_id = restaurant_kitchen_place_id
    }
    
    mutating func mapping(map: Map) {
        description                                      <- map["description"]
        status                                      <- map["status"]
        name                                      <- map["name"]
        note                                      <- map["note"]
        cancel_reason <- map["cancel_reason"]
        prefix                                      <- map["prefix"]
        price                                      <- map["price"]
        price_with_temporary                       <- map["price_with_temporary"]
        unit_type                                      <- map["unit_type"]
        quantity                                      <- map["quantity"]

        printed_quantity                                      <- map["printed_quantity"]
        id                                      <- map["id"]

        category_id                                      <- map["category_id"]
        avatar                                      <- map["avatar"]
        avatar_thump                                      <- map["avatar_thump"]
        normalize_name                                      <- map["normalize_name"]
        temporary_price                                      <- map["temporary_price"]
        temporary_percent                                      <- map["temporary_percent"]
        temporary_price_to_date                                      <- map["temporary_price_to_date"]
        temporary_price_from_date                                      <- map["temporary_price_from_date"]
        is_addition                                      <- map["is_addition"]
        
        is_addition_like_food                                      <- map["is_addition_like_food"]
        is_sell_by_weight                                      <- map["is_sell_by_weight"]

        is_allow_print                                      <- map["is_allow_print"]
        is_allow_print_stamp                                      <- map["is_allow_print_stamp"]
        is_take_away                                      <- map["is_take_away"]
        category_type                                     <- map["category_type"]
        restaurant_vat_config_id                          <- map["restaurant_vat_config_id"]
        food_in_combo                                     <- map["food_in_combo"]
        addition_foods                                     <- map["addition_foods"]
        food_options                            <- map["food_options"]
        
        //================================================================================================================================================================
        order_detail_additions                  <- map["order_detail_additions"]  //Biến này chỉ dùng để map các món con khi gọi api lấy danh sách các món cần in
        order_detail_options                    <- map["order_detail_options"]
        total_price_include_addition_foods      <- map["total_price_include_addition_foods"]
        food_unit                               <- map["food_unit"]
        //================================================================================================================================================================
        
        food_list_in_promotion_buy_one_get_one          <- map["food_list_in_promotion_buy_one_get_one"]
        restaurant_kitchen_place_id                     <- map["restaurant_kitchen_place_id"]
        is_out_stock                                    <- map["is_out_stock"]
        is_selected                                     <- map["is_selected"]
        enable_return_beer                              <- map["enable_return_beer"]
        return_quantity_for_drink                       <- map["return_quantity_for_drink"]
        order_id                                        <- map["order_id"]
        buffet_ticket_ids <- map["buffet_ticket_ids"]
        
    }
}


extension Food{
    
    
    mutating func select() -> Void {
        is_selected = ACTIVE
        if quantity <= 0 && is_selected == ACTIVE{
            quantity = is_sell_by_weight == ACTIVE ? 0.01 : 1
        }
    }
    
    
    mutating func deSelect() -> Void {
        is_selected = DEACTIVE
        
         if is_selected == DEACTIVE{
            quantity = 0
            discount_percent = 0
            note = ""
             
            addition_foods.enumerated().forEach{(i,data) in
                addition_foods[i].deSelect()
            }
             
            food_list_in_promotion_buy_one_get_one.enumerated().forEach{(i,data) in
                food_list_in_promotion_buy_one_get_one[i].deSelect()
            }
             
             
             food_options.enumerated().forEach{(i,data) in
                 food_options[i].addition_foods.enumerated().forEach{(j,data) in
                     
                     food_options[i].addition_foods[j].deSelect()
                 }
             }

            
        }
    }
    
    mutating func setQuantity(quantity:Float) -> Void {
//        let maximumNumber:Float = self.is_sell_by_weight == ACTIVE ? 200 : 1000
        let maximumNumber:Float = 1000
        self.quantity = quantity
    
        self.quantity = self.quantity >= maximumNumber ? maximumNumber : self.quantity
        
          if self.quantity > 0 {
              self.is_selected = ACTIVE
              self.addition_foods.enumerated().forEach{(i,childFood) in
                  if childFood.is_selected == ACTIVE && self.is_allow_print_stamp == ACTIVE{
                      /*
                              Nếu món chính là món in stamp
                                  if món chính bán theo kg -> thì số lượng món con luôn = 1
                                  if món chính không bán theo kg -> thì số lượng món con luôn = số lượng món chính
                              các số lượng các món con được check sẽ = với số lượng món chính
                          */
                      self.addition_foods[i].quantity = self.is_sell_by_weight == ACTIVE ? Int(1) : Int(self.quantity)
                  }
              }
              if self.category_type == .service && self.quantity > 1{
                  self.quantity = 1
              }
          }else{
              self.deSelect()
          }
    }

    
    mutating func getChildren(id:Int) -> FoodAddition? {
        var result:FoodAddition? = nil
        
        if addition_foods.count > 0{
            
            if let i = addition_foods.firstIndex(where: {$0.id == id}){
                result = addition_foods[i]
            }
            
        }else if food_list_in_promotion_buy_one_get_one.count > 0{
            
            if let i = food_list_in_promotion_buy_one_get_one.firstIndex(where: {$0.id == id}){
                result = food_list_in_promotion_buy_one_get_one[i]
            }
            
        }else if food_options.count > 0{
            
        
            food_options.forEach{data in
                if let i = data.addition_foods.firstIndex(where: {$0.id == id}){
                    result = data.addition_foods[i]
                }
            }
        
        }
            
        return result
    }
    
    
    mutating func selectChildren(id:Int) -> Void {

        if addition_foods.count > 0{
            
            if let i = addition_foods.firstIndex(where: {$0.id == id}){
                
                if is_allow_print_stamp == ACTIVE{
                /*
                       Nếu món chính là món in stamp
                       if món chính bán theo kg -> thì số lượng món con luôn = 1
                       if món chính không bán theo kg -> thì số lượng món con luôn = số lượng món chính
                       các số lượng các món con được check sẽ = với số lượng món chính
                    */
                    addition_foods[i].quantity = is_sell_by_weight == ACTIVE ? Int(1) : Int(quantity)
                    addition_foods[i].is_selected = ACTIVE
                }else {
                    addition_foods[i].select()
                }
            }
        }else if food_list_in_promotion_buy_one_get_one.count > 0{
            var childrenQuantity = 0
            
            for children in food_list_in_promotion_buy_one_get_one{
                childrenQuantity += children.quantity
            }
            
            if let i = food_list_in_promotion_buy_one_get_one.firstIndex(where: {$0.id == id}){
                if Float(childrenQuantity) < quantity{
                    food_list_in_promotion_buy_one_get_one[i].select()
                }
            }
        }
    }
    
    
    mutating func deSelectChildren(id:Int) -> Void {
        if addition_foods.count > 0{
            
            if let i = addition_foods.firstIndex(where: {$0.id == id}){
                addition_foods[i].deSelect()
            }
            
        }else if food_list_in_promotion_buy_one_get_one.count > 0{
            
            if let i = food_list_in_promotion_buy_one_get_one.firstIndex(where: {$0.id == id}){
                food_list_in_promotion_buy_one_get_one[i].deSelect()
            }
        }else if food_options.count > 0{
            
            
            food_options.enumerated().forEach{(i,data) in
                if let j = data.addition_foods.firstIndex(where: {$0.id == id}){
                    food_options[i].addition_foods[j].deSelect()
                }
            }
        
        }
        
        
        
    }
    
    mutating func setChildrenQuantity(id:Int,quantity:Int) -> Void {
        if addition_foods.count > 0{
            if let i = addition_foods.firstIndex(where: {$0.id == id}){
                addition_foods[i].setQuantity(quantity: quantity)
            }
        }else if food_list_in_promotion_buy_one_get_one.count > 0{
            if let i = food_list_in_promotion_buy_one_get_one.firstIndex(where: {$0.id == id}){
                food_list_in_promotion_buy_one_get_one[i].setQuantity(quantity: quantity)
            }
        }
    }
    

}


extension Food{
    
    static func getDummyData() -> [Food] {
        let jsonString = """
        [
          {
            "id": 7086460,
            "name": "Cá viên",
            "status": 0,
            "note": "",
            "cancel_reason": "",
            "price": 10000,
            "quantity": 2,
            "printed_quantity": 0,
            "restaurant_kitchen_place_id": 7666,
            "order_id": 844519,
            "total_price_include_addition_foods": 10000,
            "is_allow_print": 1,
            "is_allow_print_stamp": 1,
            "return_quantity_for_drink": -1,
            "food_unit": "Ly"
          },
          {
            "id": 7086461,
            "name": "Hồng trà Nho",
            "status": 0,
            "note": "",
            "cancel_reason": "",
            "price": 14000,
            "quantity": 2,
            "printed_quantity": 0,
            "restaurant_kitchen_place_id": 7662,
            "order_id": 844519,
            "total_price_include_addition_foods": 26000,
            "is_allow_print": 1,
            "is_allow_print_stamp": 1,
            "return_quantity_for_drink": -1,
            "food_unit": "Ly",
            "order_detail_options": [
              {
                "id": 45,
                "name": "Topping",
                "food_option_foods": [
                  { "id": 110811, "food_id": 24415, "food_name": "Thạch dâu", "price": 3000, "quantity": 1, "total_amount": 3000 },
                  { "id": 110812, "food_id": 24418, "food_name": "Thạch nho", "price": 3000, "quantity": 1, "total_amount": 3000 },
                  { "id": 110813, "food_id": 24421, "food_name": "Thạch đào", "price": 3000, "quantity": 1, "total_amount": 3000 },
                  { "id": 110814, "food_id": 24424, "food_name": "Thạch táo", "price": 3000, "quantity": 1, "total_amount": 3000 }
                ]
              }
            ]
          },
          {
            "id": 7086462,
            "name": "Hồng trà Bạc Hà",
            "status": 0,
            "note": "",
            "cancel_reason": "",
            "price": 14000,
            "quantity": 1,
            "printed_quantity": 0,
            "restaurant_kitchen_place_id": 7662,
            "order_id": 844519,
            "total_price_include_addition_foods": 47000,
            "is_allow_print": 1,
            "is_allow_print_stamp": 1,
            "return_quantity_for_drink": -1,
            "food_unit": "Ly",
            "order_detail_additions": [
              { "id": 7086463, "name": "Trân châu", "price": 3000, "quantity": 1, "total_price": 3000 },
              { "id": 7086464, "name": "Trái cây", "price": 3000, "quantity": 1, "total_price": 3000 },
              { "id": 7086465, "name": "Flan", "price": 3000, "quantity": 1, "total_price": 3000 },
              { "id": 7086466, "name": "UP Size", "price": 3000, "quantity": 1, "total_price": 3000 },
              { "id": 7086467, "name": "Vị Đặc Biệt", "price": 1000, "quantity": 1, "total_price": 1000 }
            ],
            "order_detail_options": [
              {
                "id": 45,
                "name": "Topping",
                "food_option_foods": [
                  { "id": 110818, "food_id": 24415, "food_name": "Thạch dâu", "price": 3000, "quantity": 1, "total_amount": 3000 },
                  { "id": 110819, "food_id": 24418, "food_name": "Thạch nho", "price": 3000, "quantity": 1, "total_amount": 3000 },
                  { "id": 110820, "food_id": 24421, "food_name": "Thạch đào", "price": 3000, "quantity": 1, "total_amount": 3000 },
                  { "id": 110821, "food_id": 24424, "food_name": "Thạch táo", "price": 3000, "quantity": 1, "total_amount": 3000 }
                ]
              },
              {
                "id": 46,
                "name": "Thạch",
                "food_option_foods": [
                  { "id": 110822, "food_id": 24427, "food_name": "Thủy tinh Dâu", "price": 4000, "quantity": 1, "total_amount": 4000 },
                  { "id": 110823, "food_id": 24430, "food_name": "Thủy tinh Yaourt", "price": 4000, "quantity": 1, "total_amount": 4000 }
                ]
              }
            ]
          },
          {
            "id": 7086468,
            "name": "Cá viên phô mai",
            "status": 0,
            "note": "",
            "cancel_reason": "",
            "price": 20000,
            "quantity": 1,
            "printed_quantity": 0,
            "restaurant_kitchen_place_id": 7666,
            "order_id": 844519,
            "total_price_include_addition_foods": 20000,
            "is_allow_print": 1,
            "is_allow_print_stamp": 1,
            "return_quantity_for_drink": -1,
            "food_unit": "Phần"
          },
          {
            "id": 7086469,
            "name": "Flan",
            "status": 0,
            "note": "",
            "cancel_reason": "",
            "price": 3000,
            "quantity": 1,
            "printed_quantity": 0,
            "restaurant_kitchen_place_id": 7662,
            "order_id": 844519,
            "total_price_include_addition_foods": 3000,
            "is_allow_print": 1,
            "is_allow_print_stamp": 1,
            "return_quantity_for_drink": -1,
            "food_unit": "Phần"
          }
        ]

        """
        
        return Mapper<Food>().mapArray(JSONString: jsonString) ?? []
        
    }

}
