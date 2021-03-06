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
        extractedFunc()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func extractedFunc() {
        characterNameLabelField.lineBreakMode = .byWordWrapping
        characterNameLabelField.numberOfLines = 0
    }

}
