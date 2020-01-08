//
//  CustomTableViewCell.swift
//  TestingAPIAlamofire
//
//  Created by khinhninmyintzu on 5/14/19.
//  Copyright © 2019 khinhninmyintzu. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell  {
    
    @IBOutlet weak var ratelbl: UILabel!
    @IBOutlet weak var rateValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
