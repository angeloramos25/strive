//
//  Saving.swift
//  Habits
//
//  Created by Angelo Ramos on 2/20/17.
//  Copyright © 2017 Palmsonntag, Inc. All rights reserved.
//

import Foundation

class Saving: NSObject, NSCoding {
    
    var wish: Wish
    var habitName: String
    var contribution: Int
    
    init(wish: Wish, habitName: String, contribution: Int) {
        self.wish = wish
        self.habitName = habitName
        self.contribution = contribution
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.wish = aDecoder.decodeObject(forKey: "wish") as! Wish
        self.habitName = aDecoder.decodeObject(forKey: "habName") as? String ?? ""
        self.contribution = aDecoder.decodeInteger(forKey: "cont")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(wish, forKey: "wish")
        aCoder.encode(habitName, forKey: "habName")
        aCoder.encode(contribution, forKey: "cont")
    }
    
}
