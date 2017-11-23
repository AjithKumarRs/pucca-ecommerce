//
//  OrderItem.swift
//  Pucca
//
//  Created by Kaung Kaung on 6/25/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class OrderItem: Object {
    dynamic var main_item_id = ""
    dynamic var detail_item_code = ""
    dynamic var detail_item_name = ""
    dynamic var image_url = ""
    dynamic var price = 0.0
    dynamic var quantity = 0
    dynamic var total_price = 0.0
}

class OrderItemSwift {
    var main_item_id = ""
    var detail_item_code = ""
    var detail_item_name = ""
    var image_url = ""
    var price = 0.0
    var quantity = 0
    var total_price = 0.0
    
    init() { }
    
    init(main_item_id: String, detail_item_code: String, detail_item_name: String, image_url: String, price: Double, quantity: Int, total_price: Double) {
        self.main_item_id = main_item_id
        self.detail_item_code = detail_item_code
        self.detail_item_name = detail_item_name
        self.image_url = image_url
        self.price = price
        self.quantity = quantity
        self.total_price = total_price
    }
}

class Category {
    var _id:String?
    var name:String?
    var thumbnail_url:String?
    var create_date: String?
    
    init() {
    }
    
    init(_id: String, name: String, thumbnail_url: String, create_date: String) {
        self._id = _id
        self.name = name
        self.thumbnail_url = thumbnail_url
        self.create_date = create_date
    }
}

class Item {
    var _id: String?
    var name: String?
    var description: String?
    var category: String?
    var item_details: [ItemDetail]?
    var image_urls: [String]?
    var thumbnail_url: String?
    
    init() {
        
    }
    
    init(_id: String, name: String, description: String, category: String, item_details: [ItemDetail], image_urls: [String], thumbnail_url: String) {
        self._id = _id
        self.name = name
        self.description = description
        self.category = category
        self.item_details = item_details
        self.image_urls = image_urls
        self.thumbnail_url = thumbnail_url
    }
}

class ItemDetail {
    var code: String?
    var name: String?
    var description: String?
    var price: Double?
    var item_counts: Int?
    var image_url: String?
    
    init() {
        
    }
    
    init(code: String, name: String, description: String, price: Double, item_counts: Int, image_url: String) {
        self.code = code
        self.name = name
        self.description = description
        self.price = price
        self.item_counts = item_counts
        self.image_url = image_url
    }
}

class DeliveryPrice {
    var id: String?
    var location: String?
    var price: Int?
    
    init() {
        
    }
    
    init(id: String, location: String, price: Int) {
        self.id = id
        self.location = location
        self.price = price
    }
}

class DeliveryPriceRealm: Object {
    dynamic var id = ""
    dynamic var locaiton = ""
    dynamic var price = 0
}

class AddressRealm: Object {
    dynamic var name = ""
    dynamic var phone = ""
    dynamic var buildingNo = ""
    dynamic var street = ""
    dynamic var township = ""
    dynamic var city = ""
}

class Api {

    static let itemsapi = "https://pucca.herokuapp.com/api/items"
    static let catgoriesapi = "https://pucca.herokuapp.com/api/categories"
    static let orderformsapi = "https://pucca.herokuapp.com/api/orderforms"
    static let deliverypricessapi = "https://pucca.herokuapp.com/api/deliveryprices"
    
}
