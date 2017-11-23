//
//  ItemDetailsTableViewCell.swift
//  Pucca
//
//  Created by Kaung Kaung on 6/21/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit

class ItemDetailsTableViewCell: UITableViewCell {
    
    var imgView: UIImageView! = UIImageView()
    var nameLabel: UILabel! = UILabel()
    var priceLabel: UILabel! = UILabel()
    
    func createUI(){
        imgView.frame = CGRect(x: 5, y: 5, width: 70, height: 70)
        nameLabel.frame = CGRect(x: 80, y: 5, width: 200, height: 35)
        priceLabel.frame = CGRect(x: 80, y: 35, width: 200, height: 35)
        
        // Testing
//        imgView.backgroundColor = .red
//        nameLabel.backgroundColor = .black
//        priceLabel.backgroundColor = .yellow
        
        self.addSubview(imgView)
        self.addSubview(nameLabel)
        self.addSubview(priceLabel)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 80)
        
        createUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
