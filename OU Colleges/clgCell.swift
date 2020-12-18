//
//  clgCell.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 28/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class clgCell: UITableViewCell {

    @IBOutlet weak var clgHdLbl: UILabel!
    @IBOutlet weak var clgTtlLbl: UILabel!
    
    @IBOutlet weak var indxLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var typLbl: UILabel!
    @IBOutlet weak var sbjctLbl: UILabel!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mblLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    
    @IBOutlet weak var prflImg: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
