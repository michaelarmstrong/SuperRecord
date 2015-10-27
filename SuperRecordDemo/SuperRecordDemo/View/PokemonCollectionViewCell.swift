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
    static let cellHeight: CGFloat = 100
    static let cellPadding: CGFloat = 10

    
    var image: UIImageView = UIImageView()

    var nameLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(nameLabel)
        self.addSubview(image)
    
        image.backgroundColor = UIColor.blueColor()
        nameLabel.backgroundColor = UIColor.redColor()
        nameLabel.font = UIFont.systemFontOfSize(12)
        nameLabel.textAlignment = .Center

        let padding = PokemonCollectionViewCell.cellPadding
        constrain(image, nameLabel) {image, label in
            image.top == image.superview!.top + padding
            image.left == image.superview!.left + padding
            image.right == image.superview!.right - padding
            
            label.bottom == label.superview!.bottom - padding
            label.height == 20
            
            align(left: image, label)
            align(right: image, label)

            distribute(by: padding, vertically:  image, label)

            
            
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
