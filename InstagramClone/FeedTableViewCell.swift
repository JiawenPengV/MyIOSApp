//
//  FeedTableViewCell.swift
//  InstagramClone
//
//  Created by Jiawen Peng on 8/19/17.
//  Copyright © 2017 Jiawen Peng. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var usernamelalbel: UILabel!
    
    @IBOutlet weak var messagelabel: UILabel!
    @IBOutlet weak var postedimage: UIImageView!
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
