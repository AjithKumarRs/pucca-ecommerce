//
//  CartViewController.swift
//  Pucca
//
//  Created by Kaung Kaung on 6/25/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let realm = try! Realm()
    let realmDeliveryPrice = try! Realm()
    
    var orderItems = [OrderItemSwift]()
    var deliveryPrice = DeliveryPrice()
    
    @IBOutlet weak var totalPriceLabelOutlet: UILabel!
    @IBOutlet weak var deliveryLocationButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func nextButtonAction(_ sender: UIButton) {
        saveRealm()
        performSegue(withIdentifier: "cartView2CartFinal", sender: nil)
    }
    
    @IBAction func deliveryLocationButtonAction(_ sender: UIButton) {
        saveRealm()
        performSegue(withIdentifier: "cart2DeliveryLocation", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hehe")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderItem = orderItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
        let url = URL(string: (orderItem.image_url ))
        cell.itemImageView.contentMode = .scaleAspectFit
        cell.itemImageView.kf.setImage(with: url,
                                       placeholder: nil,
                                       options: [.transition(ImageTransition.fade(1))],
                                       progressBlock: { receivedSize, totalSize in
                                        print("\(receivedSize)/\(totalSize)")
        },
                                       completionHandler: { image, error, cacheType, imageURL in
                                        print("Finished")
        })
        cell.totalPriceLabel.text = "\(orderItem.total_price.cleanValue) Kyats"
        cell.quantityTextField.text = "\(orderItem.quantity)"
        cell.priceLabel.text = "\(orderItem.price.cleanValue) Kyats"
        cell.nameLabel.text = "\(orderItem.detail_item_name)"
        cell.tapAction = { (cell) in
            self.orderItems.remove(at: indexPath.row)
            self.tableView.reloadData()
            self.updateTotalMoney()
        }
        
        cell.increaseAction = { (cell) in
            self.orderItems[indexPath.row].quantity += 1
            self.tableView.reloadData()
            self.updateTotalMoney()
        }
        
        cell.decreaseAction = { (cell) in
            if self.orderItems[indexPath.row].quantity > 1 {
            self.orderItems[indexPath.row].quantity -= 1
            }
            self.tableView.reloadData()
            self.updateTotalMoney()
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }
    
    func updateTotalMoney() {
        
        for orderItem in orderItems {
            orderItem.total_price = orderItem.price * Double(orderItem.quantity)
        }
        var totalmoney: Double = 0
        for orderItem in self.orderItems {
            totalmoney += orderItem.total_price
        }
        totalmoney += Double(self.deliveryPrice.price ?? 0)
        totalPriceLabelOutlet.text = "\(totalmoney.cleanValue) kyats"
    }
    
    func saveRealm() {
        let orderItemDeleteRealm = realm.objects(OrderItem.self)
        try! realm.write {
            realm.delete(orderItemDeleteRealm)
        }
        for orderItemSwift in orderItems {
            try! realm.write {
                let orderItemRealm = OrderItem()
                orderItemRealm.main_item_id = orderItemSwift.main_item_id
                orderItemRealm.detail_item_code = orderItemSwift.detail_item_code
                orderItemRealm.detail_item_name = orderItemSwift.detail_item_name
                orderItemRealm.image_url = orderItemSwift.image_url
                orderItemRealm.price = orderItemSwift.price
                orderItemRealm.quantity = orderItemSwift.quantity
                orderItemRealm.total_price = orderItemSwift.total_price
                realm.add(orderItemRealm)
            }
        }
    }
    
    
    //    var main_item_id = ""
    //    var detail_item_code = ""
    //    var detail_item_name = ""
    //    var image_url = ""
    //    var price = 0.0
    //    var quantity = 0
    //    var total_price = 0.0
    //
    //    dynamic var main_item_id = ""
    //    dynamic var detail_item_code = ""
    //    dynamic var detail_item_name = ""
    //    dynamic var image_url = ""
    //    dynamic var price = 0.0
    //    dynamic var quantity = 0
    //    dynamic var total_price = 0.0
    
    override func viewDidLoad() {
        self.automaticallyAdjustsScrollViewInsets = false
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print(realm.configuration.fileURL)
        let orderItemsRealm = realm.objects(OrderItem.self)
        for orderItemRealm in orderItemsRealm {
            let orderItem = OrderItemSwift(main_item_id: orderItemRealm.main_item_id, detail_item_code: orderItemRealm.detail_item_code, detail_item_name: orderItemRealm.detail_item_name, image_url: orderItemRealm.image_url, price: orderItemRealm.price, quantity: orderItemRealm.quantity, total_price: orderItemRealm.total_price)
            self.orderItems.append(orderItem)
        }
        
        let deliveryPricesRealm = realm.objects(DeliveryPriceRealm.self)
        for deliveryPriceRealm in deliveryPricesRealm {
            self.deliveryPrice = DeliveryPrice(id: deliveryPriceRealm.id, location: deliveryPriceRealm.locaiton, price: deliveryPriceRealm.price)
        }
        if self.deliveryPrice.location == "" || self.deliveryPrice.price == 0||self.deliveryPrice.location == nil || self.deliveryPrice.price == nil {
            deliveryLocationButtonOutlet.setTitle("Please choose delivery township", for: .normal)
        } else {
        deliveryLocationButtonOutlet.setTitle("\(self.deliveryPrice.location ?? "") - \(self.deliveryPrice.price ?? 0) Kyats", for: .normal)
        }
        updateTotalMoney()
    }
}
