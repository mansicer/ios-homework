//
//  ShoppingItemTableViewCell.swift
//  HW4-ShoppingList
//
//  Created by 张福翔 on 2020/11/9.
//

import UIKit

@IBDesignable class ShoppingItemTableViewCell: UITableViewCell {
    // MARK: properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingPickerView: RatingPickerView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
