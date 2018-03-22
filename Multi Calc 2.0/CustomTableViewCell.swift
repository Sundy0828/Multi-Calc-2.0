//
//  CustomTableViewCell.swift
//  Multi Calc 2.0
//
//  Created by Jerrod on 3/19/18.
//  Copyright © 2018 Jerrod Sunderland. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var calcLbl: UILabel!
    @IBOutlet var markLbl: UILabel!
    @IBOutlet var scoreLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
