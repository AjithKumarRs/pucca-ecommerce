//
//  TestingTableViewCell.swift
//  Pucca
//
//  Created by Kaung Kaung on 10/11/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit

class TestingTableViewCell: UITableViewCell {

    var imgView: UIImageView! = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.frame = CGRect(x: (self.frame.width / 2) + 10, y: 10, width: 40, height: 60)
        
        self.addSubview(imgView)
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 80)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
