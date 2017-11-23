//
//  DeliveryLocaitonViewController.swift
//  Pucca
//
//  Created by Kaung Kaung on 7/25/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class DeliveryLocaitonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    let deliveryPriceAPI = Api.deliverypricessapi
    var locationPrices = [DeliveryPrice]()
    
    func fetchData() {
        Alamofire.request(deliveryPriceAPI).responseData { response in
            if let data = response.result.value {
                do {
                    let dataArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
                    for data in dataArray {
                        let dataDict = data as? [String:Any]
                        let id = dataDict?["_id"] as? String ?? ""
                        let location = dataDict?["location"] as? String ?? ""
                        let price = dataDict?["price"] as? Int ?? 0
                        
                        let deliveryPrice = DeliveryPrice(id: id, location: location, price: price)
                        self.locationPrices.append(deliveryPrice)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                self.tableView.reloadData()
            }
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeliveryLocationTableViewCell
        let deliveryPrice = locationPrices[indexPath.row]
        cell.priceLabelOutlet.text = "\(deliveryPrice.price ?? 0) kyats"
        cell.locationLabelOutlet.text = deliveryPrice.location
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        let deliveryPriceRealm = DeliveryPriceRealm()
        let deliveryPrice = locationPrices[indexPath.row]
        deliveryPriceRealm.id = deliveryPrice.id ?? ""
        deliveryPriceRealm.locaiton = deliveryPrice.location ?? ""
        deliveryPriceRealm.price = deliveryPrice.price ?? 0
        try! realm.write {
            realm.add(deliveryPriceRealm)
        }
        performSegue(withIdentifier: "deliveryLocation2cart", sender: nil)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    
}
