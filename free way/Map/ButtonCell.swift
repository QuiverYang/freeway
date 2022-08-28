//
//  ButtonCell.swift
//  free way
//
//  Created by Menglin Yang on 2022/8/27.
//

import UIKit

class ButtonCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    static let identifier = "cell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        UINib(nibName: "ButtonCell", bundle: nil)
    }

}
