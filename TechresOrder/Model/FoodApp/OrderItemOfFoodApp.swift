//
//  OrderItemOfFoodApp.swift
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 31/08/2024.
//

import UIKit
import ObjectMapper


struct OrderItemOfFoodApp: Mappable {
    var id = 0
   

    var food_id:String = ""
    var name = ""

    var vat_percent:Float = 0
    var vat_amount:Float = 0
    var quantity:Float = 0
    var price:Double = 0
    var total_price:Double = 0

    var note:String = ""

    var food_options:[OrderItemChildrenOfFoodApp] = []

    

    
    var food_name:String? =  nil{
        didSet{
            guard let food_name = self.food_name else {
                return
            }
            
            
            self.name = food_name
        }
    }
    
    var total_price_addition:Double = 0
    

    
        
    init?(map: Map) {}
    
    init(){}
    
    init(name:String,price:Double,quantity:Float,total_price:Double,food_options:[OrderItemChildrenOfFoodApp] = []){
        self.name = name
        self.price = price
        self.quantity = quantity
        self.total_price = total_price
        self.food_options = food_options
    }
        
    mutating func mapping(map: Map) {
     
        id  <- map["id"]

        food_id  <- map["food_id"]
        name <- map["name"]

        vat_percent <- map["vat_percent"]
        vat_amount <- map["vat_amount"]
        quantity  <- map["quantity"]
        price  <- map["price"]
        total_price  <- map["total_price"]

        note  <- map["note"]

        food_options <- map["food_options"]
        
        
        total_price_addition <- map["total_price_addition"]
        food_name  <- map["food_name"]

    }
}


struct OrderItemChildrenOfFoodApp: Mappable {
    var name = ""
    var quantity = 0
    var price = 0
 
    init?(map: Map) {}
    
    init(){}
    
    init(name:String,quantity:Int,price:Int){
        self.name = name
        self.quantity = quantity
        self.price = price
    }
    
  
    mutating func mapping(map: Map) {
     
        name  <- map["name"]
        quantity  <- map["quantity"]
        price  <- map["price"]
      
    }
}
