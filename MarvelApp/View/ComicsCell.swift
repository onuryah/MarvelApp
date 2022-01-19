//
//  ComicsCell.swift
//  MarvelApp
//
//  Created by Ceren Çapar on 19.01.2022.
//

import UIKit

class ComicsCell: UITableViewCell {
    @IBOutlet weak var comicNameLabelField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        extractedFunc()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    fileprivate func extractedFunc() {
        comicNameLabelField.lineBreakMode = .byWordWrapping
        comicNameLabelField.numberOfLines = 0
    }

}
