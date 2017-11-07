//
//  FilmTableViewCell.swift
//  piQuadrat
//
//  Created by pau on 10/31/17.
//  Copyright © 2017 pau. All rights reserved.
//

import UIKit

class FilmTableViewCell: UITableViewCell {
    //MARK: Properties
 
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var levelOfUnderstanding: UIImageView!
    @IBOutlet weak var hasSeenImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
