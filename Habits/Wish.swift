//
//  Goal.swift
//  Habits
//
//  Created by Angelo Ramos on 1/28/17.
//  Copyright © 2017 Palmsonntag, Inc. All rights reserved.
//

import Foundation

class Wish: NSObject, NSCoding {
    
    var name: String
    var cost: Int
    var count: Int
    var picPath: String
    var id: String
    var completed: Bool
    
    init(name: String, cost: Int, imagePath: String) {
        self.name = name
        self.cost = cost
        self.count = 0
        self.picPath = imagePath
        self.id = name
        self.completed = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.cost = aDecoder.decodeInteger(forKey: "cost")
        self.count = aDecoder.decodeInteger(forKey: "count")
        self.picPath = aDecoder.decodeObject(forKey: "picPath") as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        self.completed = aDecoder.decodeBool(forKey: "completed")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(cost, forKey: "cost")
        aCoder.encode(count, forKey: "count")
        aCoder.encode(picPath, forKey: "picPath")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(completed, forKey: "completed")
    }

}
