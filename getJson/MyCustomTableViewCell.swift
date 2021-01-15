//
//  MyCustomTableViewCell.swift
//  getJson
//
//  Created by YoNa on 2020/12/11.
//

import UIKit

class MyCustomTableViewCell: UITableViewCell {
    @IBOutlet weak var  makerLabel: UILabel!
    @IBOutlet weak var  productNameLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
