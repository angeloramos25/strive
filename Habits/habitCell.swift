//
//  habitCell.swift
//  Habits
//
//  Created by Angelo Ramos on 1/26/17.
//  Copyright © 2017 Palmsonntag, Inc. All rights reserved.
//

import UIKit

class habitCell: UICollectionViewCell {
    
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var editButt: UIButton!
    @IBOutlet weak var deleteButt: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
   
    override func awakeFromNib() {
        self.contentView.autoresizingMask = [UIViewAutoresizing.flexibleWidth , UIViewAutoresizing.flexibleHeight]
    }
    
}
