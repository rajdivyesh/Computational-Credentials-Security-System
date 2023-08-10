//
//  ListWithItemAndNameCell.swift
//  PrjPasswordManager
//
//  Created by Karansinh Parmar on 2023-04-16.
//

import UIKit

class ListWithItemAndNameCell: UITableViewCell {
    
    static let identifier = "ListWithItemAndNameCell"
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var headName: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
