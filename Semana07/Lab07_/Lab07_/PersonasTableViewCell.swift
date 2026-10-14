//
//  PersonasTableViewCell.swift
//  Lab07_
//
//  Created by Tecsup on 14/10/26.
//

import UIKit

class PersonasTableViewCell: UITableViewCell {

    @IBOutlet weak var PersonaImagen: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var personaNombre: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
