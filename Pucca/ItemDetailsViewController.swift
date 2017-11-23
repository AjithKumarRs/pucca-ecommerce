//
//  ViewController.swift
//  Pucca
//
//  Created by Kaung Kaung on 6/20/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class ItemDetailsViewController: UIViewController , UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var quantityStackViewOutlet: UIStackView!
    @IBOutlet weak var quantityLabelOutlet: UILabel!
    @IBOutlet weak var cartButtonOutlet: UIButton!
    @IBOutlet weak var informationStackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segementedControlOutlet: UISegmentedControl!
    
    @IBAction func decreaseButtonAction(_ sender: UIButton) {
        if self.quantity > 1 {
            print("decrease pressed")
            self.quantity -= 1
            quantityLabelOutlet.text = "\(self.quantity)"
        }
    }
    @IBAction func increaseButtonAction(_ sender: UIButton) {
        print("increase pressed")
        self.quantity += 1
        quantityLabelOutlet.text = "\(self.quantity)"
    }
    @IBAction func cartButtonAction(_ sender: UIButton) {
        if mode == 0 {
            performSegue(withIdentifier: "itemDetails2cartView", sender: nil)
        } else {
            if selectedItemDetailsIndex == -1 {
                let alert = UIAlertController(title: "Please choose item first", message: "An item must be selected to perform add to cart", preferredStyle: .alert)
                let viewcartaction = UIAlertAction(title: "OK", style: .default, handler: { (alertaction) in
                    print("USER CLICKED")
                })
                alert.addAction(viewcartaction)
                present(alert, animated: false, completion: {
                    print("USER COMPLETION")
                })
            } else {
                let realm = try! Realm()
                let orderItem = OrderItem()
                
                orderItem.main_item_id = currentItem._id ?? ""
                orderItem.detail_item_code = currentItem.item_details?[selectedItemDetailsIndex].code ?? ""
                orderItem.detail_item_name = currentItem.item_details?[selectedItemDetailsIndex].name ?? ""
                orderItem.image_url = currentItem.item_details?[selectedItemDetailsIndex].image_url ?? ""
                orderItem.price = currentItem.item_details?[selectedItemDetailsIndex].price ?? 0.0
                orderItem.quantity = self.quantity
                orderItem.total_price = currentItem.item_details?[selectedItemDetailsIndex].price ?? 0.0
                
                try! realm.write {
                    realm.add(orderItem)
                }
                var message = "DEFAULT MESSAGE"
                if quantity < 2 {
                    message = "\(currentItem.item_details?[selectedItemDetailsIndex].name ?? "") has been added to cart"
                } else {
                    message = "\(quantity) \(currentItem.item_details?[selectedItemDetailsIndex].name ?? "") have been added to cart"
                }
                let alert = UIAlertController(title: "Add to cart", message: message, preferredStyle: .alert)
                let viewcartaction = UIAlertAction(title: "OK", style: .default, handler: { (alertaction) in
                    print("USER CLICKED")
                })
                alert.addAction(viewcartaction)
                present(alert, animated: false, completion: {
                    print("USER COMPLETION on selected item")
                })
                
                
            }
        }
    }
    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        mode = sender.selectedSegmentIndex
        if mode == 0 {
            cartButtonOutlet.setTitle("View Cart", for: .normal)
            tableView.isHidden = true
            informationStackView.isHidden = false
            self.itemImgsCoatedView.isHidden = false
            self.itemDetailsImgsCoatedView.isHidden = true
            self.quantityStackViewOutlet.isHidden = true
        } else {
            cartButtonOutlet.setTitle("Add To Cart", for: .normal)
            tableView.isHidden = !true
            informationStackView.isHidden = !false
            self.itemImgsCoatedView.isHidden = true
            self.itemDetailsImgsCoatedView.isHidden = false
            self.quantityStackViewOutlet.isHidden = !true
        }
    }
    
    var itemImgsCoatedView = UIView()
    var itemDetailsImgsCoatedView = UIView()
    var mode = 0 // 0 - Information 1 - Selection
    let itemIndexNumber = 0
    var quantity = 1
    var priceArray = [Double]()
    var minPrice = Double()
    var maxPrice = Double()
    var currentItem = Item()
    var selectedItemDetailsIndex = -1
    var selectedItemDetails = ItemDetail()
    var selectedItemDetailsImgView = UIImageView()
    
    func updateCoatedViewFrame(itemImgsCoatedView: UIView, scrollView: UIView) -> UIView {
        itemImgsCoatedView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        return itemImgsCoatedView
    }
    
    func fetchAndUpdateData() {
        
        for item_detail in (self.currentItem.item_details!) {
            self.priceArray.append(item_detail.price!)
        }
        
        var i = 0
        
        let scrollViewWidth = ( self.scrollView.frame.height ) * CGFloat((self.currentItem.image_urls?.count)!)
        self.scrollView.contentSize = CGSize(width: scrollViewWidth - 10, height: 0)
        
        self.itemImgsCoatedView = self.updateCoatedViewFrame(itemImgsCoatedView: self.itemImgsCoatedView, scrollView: self.scrollView)
        OperationQueue.main.addOperation {
            self.itemImgsCoatedView.frame = CGRect(x: 0, y: 0, width: self.itemImgsCoatedView.frame.width, height: self.itemImgsCoatedView.frame.height)
        }
        
        
        self.itemDetailsImgsCoatedView = self.updateCoatedViewFrame(itemImgsCoatedView: self.itemDetailsImgsCoatedView, scrollView: self.scrollView)
        self.scrollView.addSubview(self.itemDetailsImgsCoatedView)
        self.itemDetailsImgsCoatedView.addSubview(self.selectedItemDetailsImgView)
        self.selectedItemDetailsImgView.contentMode = .scaleAspectFit
        self.selectedItemDetailsImgView.image = UIImage(named: "defaultImage.jpg")
        self.selectedItemDetailsImgView.frame = self.itemDetailsImgsCoatedView.frame
        
        for imgurl in (self.currentItem.image_urls!) {
            
            let imgView = self.createImgView(imgUrl: imgurl, index: i)
            i = i + 1
            self.itemImgsCoatedView.addSubview(imgView)
        }
        
        
        self.minPrice = self.priceArray.min()!
        self.maxPrice = self.priceArray.max()!
        
        self.nameLabel.text = self.currentItem.name
        self.descriptionLabel.text = self.currentItem.description
        self.categoryLabel.text = self.currentItem.category
        self.priceLabel.text = "\(self.minPrice.cleanValue)Ks - \(self.maxPrice.cleanValue)Ks"
        
        self.tableView.reloadData()
        
    }
    
    func createImgView(imgUrl: String, index: Int) -> UIImageView {
        let imgView = UIImageView()
        
        imgView.frame = CGRect(x: 10 + (CGFloat(index) * self.scrollView.frame.height), y: 10, width: scrollView.frame.height - 20 , height: scrollView.frame.height - 20)
        
        let url = URL(string: imgUrl)
        OperationQueue.main.addOperation {
            
            
            imgView.kf.setImage(with: url,
                                placeholder: nil,
                                options: [.transition(ImageTransition.fade(1))],
                                progressBlock: { receivedSize, totalSize in
                                    print("\(receivedSize)/\(totalSize)")
            },
                                completionHandler: { image, error, cacheType, imageURL in
                                    print("Finished")
            })
        }
        print("Return")
        
        return imgView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentItem.item_details?.count ?? 0
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemDetailsTableViewCell
        let url = URL(string: (self.currentItem.item_details?[indexPath.row].image_url)!)
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imgView.kf.setImage(with: url,
                                 placeholder: nil,
                                 options: [.transition(ImageTransition.fade(1))],
                                 progressBlock: { receivedSize, totalSize in
                                    print("\(receivedSize)/\(totalSize)")
        },
                                 completionHandler: { image, error, cacheType, imageURL in
                                    print("Finished")
        })
        cell.nameLabel.text = currentItem.item_details?[indexPath.row].name
        cell.priceLabel.text = "\(currentItem.item_details?[indexPath.row].price?.cleanValue ?? "" ) Kyats"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItemDetailsIndex = indexPath.row
        selectedItemDetails = (currentItem.item_details?[indexPath.row])!
        print(selectedItemDetails.code ?? "")
        print(indexPath.row)
        let url = URL(string: (self.selectedItemDetails.image_url)!)
        selectedItemDetailsImgView.kf.setImage(with: url,
                                               placeholder: nil,
                                               options: [.transition(ImageTransition.fade(1))],
                                               progressBlock: { receivedSize, totalSize in
                                                print("\(receivedSize)/\(totalSize)")
        },
                                               completionHandler: { image, error, cacheType, imageURL in
                                                print("Finished")
        })
    }
    
    func prepareUI() {
        cartButtonOutlet.setTitle("View Cart", for: .normal)
        quantityLabelOutlet.text = "\(quantity)"
        tableView.isHidden = true
        informationStackView.isHidden = false
        self.quantityStackViewOutlet.isHidden = true
        self.itemImgsCoatedView.isHidden = false
        self.itemDetailsImgsCoatedView.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        prepareUI()
        fetchAndUpdateData()
        scrollView.addSubview(self.itemImgsCoatedView)
        self.itemImgsCoatedView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
    }
}

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

