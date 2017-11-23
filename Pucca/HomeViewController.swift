//
//  HomeViewController.swift
//  Pucca
//
//  Created by Kaung Kaung on 6/23/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var modeSegmentOutlet: UISegmentedControl!
    @IBAction func modeSegmentAction(_ sender: UISegmentedControl) {
        self.mode = sender.selectedSegmentIndex
        self.collectionView.reloadData()
    }
    
    var mode = 0
    var latestItems = [Item]()
    var items = [Item]()
    var gridLayout: GridLayout = GridLayout(numberOfColumns: 2)
    var categories = [Category]()
    let allItemsAPI = Api.itemsapi
    let allCategorisAPI = Api.catgoriesapi
    var categoryItems = [Item]()
    
    func fetchAndUpdateData() {
        var returnitems = [Item]()
        
        Alamofire.request(allCategorisAPI).responseData { response in
            if let data = response.result.value {
                do {
                    let dataArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
                    print(response)
                    for data in dataArray {
                        let dataDict = data as? [String:Any]
                        let _id = dataDict?["_id"] as? String ?? ""
                        let name = dataDict?["name"] as? String ?? ""
                        let thumbnail_url = dataDict?["thumbnail_url"] as? String ?? ""
                        let create_date = dataDict?["create_date"] as? String ?? ""
                        
                        let category = Category(_id: _id, name: name, thumbnail_url: thumbnail_url, create_date: create_date)
                        self.categories.append(category)
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
                
                self.collectionView.reloadData()
            }
        }
        
        Alamofire.request(allItemsAPI).responseData { response in
            print("CALLED")
            if let data = response.result.value {
                do {
                    let dataArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
                    for data in dataArray {
                        let dataDict = data as? [String:Any]
                        let _id = dataDict?["_id"] as? String ?? "UNKNOWN"
                        let name = dataDict?["name"] as? String ?? "UNKNOWN"
                        let description = dataDict?["description"] as? String ?? "UNKNOWN"
                        let category = dataDict?["category"] as? String ?? "UNKNOWN"
                        let item_details_array = dataDict?["item_details"] as? [Any]
                        let image_urls = dataDict?["image_urls"] as? [String]
                        let thumbnail_url = dataDict?["thumbnail_url"] as? String ?? "UNKNOWN"
                        
                        var item_details = [ItemDetail]()
                        for item_details_data in item_details_array! {
                            let item_details_dict = item_details_data as? [String:Any]
                            let code = item_details_dict?["code"] as? String ?? "UNKNOWN"
                            let name = item_details_dict?["name"] as? String ?? "UNKNOWN"
                            let description = item_details_dict?["description"] as? String ?? "UNKNOWN"
                            let price = item_details_dict?["price"] as? Double ?? 0.0
                            let item_counts = item_details_dict?["item_counts"] as? Int ?? 0
                            let image_url = item_details_dict?["image_url"] as? String ?? "UNKNOWN"
                            
                            let itemDetail = ItemDetail(code: code, name: name, description: description, price: price, item_counts: item_counts, image_url: image_url)
                            item_details.append(itemDetail)
                        }
                        
                        let item = Item(_id: _id, name: name, description: description, category: category, item_details: item_details, image_urls: image_urls!, thumbnail_url: thumbnail_url)
                        
                        returnitems.append(item)
                    }
                }
                catch {
                    print(error)
                }
                self.items = returnitems
                var i = 0
                
                for item in self.items {
                    print(item._id ?? "")
                }
                
                for returnItem in returnitems.reversed() {
                    print(returnItem._id)
                    self.latestItems.append(returnItem)
                    i = i + 1
                    if i > 9 {
                        return
                    }
                }
                
                self.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! HomeCollectionViewCell
        
        if mode == 0 {
            var minprice = 0.0
            var maxprice = 0.0
            var prices = [Double]()
            let itemdetails = latestItems[indexPath.row].item_details
            for itemdetail in itemdetails! {
                prices.append(itemdetail.price ?? 0.0)
            }
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = 4
            minprice = prices.min() ?? 0.0
            maxprice = prices.max() ?? 0.0
            cell.priceLabel?.text = "\(minprice.cleanValue) - \(maxprice.cleanValue) Kyats"
            cell.nameLabel?.text = latestItems[indexPath.row].name ?? "NULL"
            cell.nameLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.priceLabel?.font = UIFont.systemFont(ofSize: 12)
            OperationQueue.main.addOperation {
                cell.nameLabel?.numberOfLines = 0
                cell.nameLabel?.textAlignment = NSTextAlignment.left
            }
            let url = URL(string :(latestItems[indexPath.row].thumbnail_url)!)
            //        let url = URL(string: (self.currentItem.item_details?[indexPath.row].image_url)!)
            cell.imageView?.kf.setImage(with: url,
                                        placeholder: nil,
                                        options: [.transition(ImageTransition.fade(1))],
                                        progressBlock: { receivedSize, totalSize in
                                            print("\(receivedSize)/\(totalSize)")
            },
                                        completionHandler: { image, error, cacheType, imageURL in
                                            print("Finished")
            })
            
        }
        else if self.mode == 1 {
            
            cell.nameLabel?.text = categories[indexPath.row].name ?? "NULL"
            OperationQueue.main.addOperation {
                cell.nameLabel?.numberOfLines = 0
                cell.nameLabel?.textAlignment = NSTextAlignment.left
            }
            let url = URL(string :(categories[indexPath.row].thumbnail_url)!)
            //        let url = URL(string: (self.currentItem.item_details?[indexPath.row].image_url)!)
            cell.imageView?.kf.setImage(with: url,
                                        placeholder: nil,
                                        options: [.transition(ImageTransition.fade(1))],
                                        progressBlock: { receivedSize, totalSize in
                                            print("\(receivedSize)/\(totalSize)")
            },
                                        completionHandler: { image, error, cacheType, imageURL in
                                            
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0
        if mode == 0 {
            numberOfItems = latestItems.count
        } else if mode == 1 {
            numberOfItems = categories.count
        }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mode == 0 {
            performSegue(withIdentifier: "home2ItemDetails", sender: latestItems[indexPath.row])
        } else if mode == 1 {
            var categoryItems = [Item]()
            for item in self.items {
                
                if item.category == categories[indexPath.row].name! {
                    print("Found Matched")
                    categoryItems.append(item)
                    print(categories[indexPath.row].name!)
                }
            }
            self.categoryItems = categoryItems
            performSegue(withIdentifier: "home2Items", sender: self.categoryItems)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "home2ItemDetails" {
            if let viewController = segue.destination as? ItemDetailsViewController {
                viewController.currentItem = (sender as? Item)!
            }
        } else if segue.identifier == "home2Items" {
            if let viewController = segue.destination as? ItemsViewController {
                viewController.categoryItems = (sender as? [Item])!
            }
        }
    }
//
//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        <#code#>
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        collectionView.collectionViewLayout = gridLayout
        fetchAndUpdateData()
    }
    
    
}
