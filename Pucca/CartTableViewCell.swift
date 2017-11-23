//
//  CartTableViewCell.swift
//  Pucca
//
//  Created by Kaung Kaung on 7/4/17.
//  Copyright © 2017 CodeRed. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var quantityTextField: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var increaseButtonOutlet: UIButton!
    @IBOutlet weak var decreaseButtonOutlet: UIButton!
    @IBAction func increaseButtonAction(_ sender: UIButton) {
        increaseAction?(self)
    }
    @IBAction func decreaseButtonAction(_ sender: UIButton) {
        decreaseAction?(self)
    }
    @IBAction func removeButtonAction(_ sender: AnyObject) {
        tapAction?(self)
    }
    
    var tapAction: ((UITableViewCell) -> Void)?
    var increaseAction: ((UITableViewCell) -> Void)?
    var decreaseAction: ((UITableViewCell) -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.increaseButtonOutlet.layer.borderColor = UIColor(red: 39/255, green: 125/255, blue: 246/255, alpha: 1).cgColor
        self.increaseButtonOutlet.layer.borderWidth = 1
        self.increaseButtonOutlet.layer.cornerRadius = 7
        
        
        self.decreaseButtonOutlet.layer.borderColor = UIColor(red: 39/255, green: 125/255, blue: 246/255, alpha: 1).cgColor
        self.decreaseButtonOutlet.layer.borderWidth = 1
        self.decreaseButtonOutlet.layer.cornerRadius = 7

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
