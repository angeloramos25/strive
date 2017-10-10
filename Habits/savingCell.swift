//
//  savingCell.swift
//  Habits
//
//  Created by Angelo Ramos on 2/20/17.
//  Copyright © 2017 Palmsonntag, Inc. All rights reserved.
//

import UIKit

class savingCell: UICollectionViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wishNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var dim: UIView!
    
    override func awakeFromNib() {
        self.contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
    }
    
}
