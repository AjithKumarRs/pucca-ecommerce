//
//  CartFinalViewController.swift
//  Pucca
//
//  Created by Kaung Kaung on 6/29/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class CartFinalViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextFieldOutlet: UITextField!
    @IBOutlet weak var phoneTextFieldOutlet: UITextField!
    @IBOutlet weak var buildingNoTextFieldOutlet: UITextField!
    @IBOutlet weak var streetTextFieldOutlet: UITextField!
    @IBOutlet weak var townshipTextFieldOutlet: UITextField!
    @IBOutlet weak var cityTextFieldOutlet: UITextField!
    
    var orderFormAPI = Api.orderformsapi
    var name: String = ""
    var phone: String = ""
    var buildingNo: String = ""
    var street: String = ""
    var township: String = ""
    var city: String = ""
    
    let realm = try! Realm()
    
    func saveToRealm() {
        try! realm.write {
            let addressRealm = AddressRealm()
            addressRealm.name = self.name
            addressRealm.phone = self.phone
            addressRealm.buildingNo = self.buildingNo
            addressRealm.street = self.street
            addressRealm.township = self.township
            addressRealm.city = self.city
            realm.add(addressRealm)
        }
    }
    
    //    Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default)
    
    func createOrderItemParameter() -> Parameters {
        
        let orderItemsRealm = realm.objects(OrderItem.self)
        var orderItems = [Any]()
        for orderItem in orderItemsRealm{
            var orderItemDictionary = [String : Any]()
            orderItemDictionary["main_item_id"] = orderItem.main_item_id
            orderItemDictionary["detail_item_code"] = orderItem.detail_item_code
            orderItemDictionary["detail_item_name"] = orderItem.detail_item_name
            orderItemDictionary["image_url"] = orderItem.image_url
            orderItemDictionary["price"] = orderItem.price
            orderItemDictionary["quantity"] = orderItem.quantity
            orderItemDictionary["total_price"] = orderItem.total_price
            orderItems.append(orderItemDictionary)
        }
        
        let parameters: Parameters = [
            "name": name,
            "phone_number": phone,
            "address": [
                "building_no": buildingNo,
                "street": street,
                "township": township,
                "city": city
            ],
            "order_item" : orderItems
        ]
        return parameters
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        fetchData()
        return false
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        fetchData()
        saveToRealm()
        Alamofire.request(orderFormAPI, method: .post, parameters: createOrderItemParameter(), encoding: JSONEncoding.default)
    }
    
    func fetchData() {
        self.name = nameTextFieldOutlet.text ?? ""
        self.phone = phoneTextFieldOutlet.text ?? ""
        self.buildingNo = buildingNoTextFieldOutlet.text ?? ""
        self.street = streetTextFieldOutlet.text ?? ""
        self.township = townshipTextFieldOutlet.text ?? ""
        self.city = cityTextFieldOutlet.text ?? ""
    }
    
    func setUp() {
        let addressesRealm = realm.objects(AddressRealm.self)
        for addressRealm in addressesRealm {
            nameTextFieldOutlet.text = addressRealm.name
            phoneTextFieldOutlet.text = addressRealm.phone
            buildingNoTextFieldOutlet.text = addressRealm.buildingNo
            streetTextFieldOutlet.text = addressRealm.street
            townshipTextFieldOutlet.text = addressRealm.township
            cityTextFieldOutlet.text = addressRealm.city
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        setUp()
    }
}
