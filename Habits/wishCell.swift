//
//  wishCell.swift
//  Habits
//
//  Created by Angelo Ramos on 1/30/17.
//  Copyright © 2017 Palmsonntag, Inc. All rights reserved.
//

import UIKit

class wishCell: UICollectionViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var deleteButt: UIButton!
    @IBOutlet weak var editButt: UIButton!
    
    
    override func awakeFromNib() {
        self.contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
    }
    
}
