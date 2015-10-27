//
//  PokemonCollectionViewCell.swift
//  SuperRecordDemo
//
//  Created by Piergiuseppe Longo on 27/10/15.
//  Copyright © 2015 SuperRecord. All rights reserved.
//

import UIKit
import Cartography

class PokemonCollectionViewCell: UICollectionViewCell {

    static let cellWidth: CGFloat = 100
    static let cellHeight: CGFloat = 130
    static let imgSize: CGFloat = 80

    static let cellPadding: CGFloat = 10

    
    var image: UIImageView = UIImageView()

    var nameLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(nameLabel)
        self.addSubview(image)
    
        nameLabel.font = UIFont.systemFontOfSize(12)
        nameLabel.textAlignment = .Center
        image.contentMode = UIViewContentMode.ScaleAspectFit
        let padding = PokemonCollectionViewCell.cellPadding
        let imageSize = PokemonCollectionViewCell.imgSize
        constrain(image, nameLabel) {image, label in
            image.top == image.superview!.top + padding
            image.width == imageSize
            image.height == imageSize
            image.centerX == image.superview!.centerX
            
            label.top == image.bottom + padding
            label.bottom == label.superview!.bottom - padding
            label.left == label.superview!.left + padding
            label.right == label.superview!.right - padding
    
        }
        



    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
