//
//  HomeCollectionViewCell.swift
//  Pucca
//
//  Created by Kaung Kaung on 6/23/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    var imageView : UIImageView? = UIImageView()
    var nameLabel : UILabel? = UILabel()
    
    
    func createUI() {
        
        let imageView = UIImageView()
        let nameLabel = UILabel()
        
        self.imageView = imageView
        self.nameLabel = nameLabel
        
        self.imageView?.contentMode = .scaleAspectFit
        
        //        self.imageView?.backgroundColor = .black
        //        self.nameLabel?.backgroundColor = .green
        
        self.imageView?.frame = CGRect(x: self.frame.width * 0.1 , y: self.frame.height * 0.1 , width: self.frame.width * 0.8, height: self.frame.height * 0.7)
        self.nameLabel?.frame = CGRect(x: self.frame.width * 0.1, y: self.frame.height * 0.9, width: self.frame.width * 0.8, height: self.frame.height * 0.15)
        
        self.addSubview(self.imageView!)
        self.addSubview(self.nameLabel!)
        
        //        self.backgroundColor = .red
    }
    
    override func awakeFromNib() {
        createUI()
    }
}
