//
//  CharityCellView.swift
//  Omise-Challenge
//
//  Created by Shivam on 13/03/18.
//  Copyright © 2018 Omise. All rights reserved.
//

import UIKit

class CharityCellView: UITableViewCell {
    
    @IBOutlet weak var charityName: UILabel!
    @IBOutlet weak var charityImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
