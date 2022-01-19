//
//  CharacterCell.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 18.01.2022.
//

import UIKit

class CharacterCell: UITableViewCell {
    @IBOutlet weak var characterNameLabelField: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
