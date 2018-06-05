//
//  textPostTableViewCell.swift
//  AC-iOS 4.3 Final-Retake - Practical
//
//  Created by C4Q on 6/2/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class textPostTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
