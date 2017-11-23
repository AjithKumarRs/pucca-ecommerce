//
//  DeliveryLocaitonViewController.swift
//  Pucca
//
//  Created by Kaung Kaung on 7/25/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ImgTestingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    var img_urls_array = [[String]]()
    
    func fetchData() {
        Alamofire.request("http://localhost:2000/api/imgs").responseData { response in
            if let data = response.result.value {
                do {
                    let dataArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
                    for data in dataArray {
                        let dataDict = data as? [String:Any]
                        let img_urls = dataDict!["img_url"] as? [String] ?? [""]
                        self.img_urls_array.append(img_urls)
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
        return img_urls_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TestingTableViewCell
        let current_img_url = "http://" + img_urls_array[indexPath.row][0]
        
        let url = URL(string : current_img_url ?? "")!
        print(url)
        cell.imgView.kf.setImage(with: url,
                                 placeholder: nil,
                                 options: [.transition(ImageTransition.fade(1))],
                                 progressBlock: { receivedSize, totalSize in
                                    print("\(receivedSize)/\(totalSize)")
        },
                                 completionHandler: { image, error, cacheType, imageURL in
                                    print("->" , error , "<-" )
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("do nth")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view didload start")
        tableView.delegate = self
        tableView.dataSource = self
        fetchData()
    }
    
    
}


