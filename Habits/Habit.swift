//
//  Habit.swift
//  Habits
//
//  Created by Angelo Ramos on 1/21/17.
//  Copyright © 2017 Palmsonntag, Inc. All rights reserved.
//

import Foundation

class Habit: NSObject, NSCoding {
    
    var name: String
    var goal: Int
    var freq: Int
    var streak: Int
    var build: Bool
    var quit: Bool
    var counter: Int
    var wishes: [String: Int]
    
    init(name: String, goal: Int, freq: Int, build: Bool, quit: Bool, wishes: [String: Int]) {
        
        self.name = name
        self.goal = goal
        self.freq = freq
        self.counter = 0
        self.streak = 0
        self.build = build
        self.quit = quit
        self.wishes = wishes
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.goal = aDecoder.decodeInteger(forKey: "goal")
        self.freq = aDecoder.decodeInteger(forKey: "freq")
        self.streak = aDecoder.decodeInteger(forKey: "streak")
        self.build = aDecoder.decodeBool(forKey: "build")
        self.quit = aDecoder.decodeBool(forKey: "quit")
        self.counter = aDecoder.decodeInteger(forKey: "counter")
        self.wishes = aDecoder.decodeObject(forKey: "wishes") as! [String: Int]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(goal, forKey: "goal")
        aCoder.encode(freq, forKey: "freq")
        aCoder.encode(streak, forKey: "streak")
        aCoder.encode(build, forKey: "build")
        aCoder.encode(quit, forKey: "quit")
        aCoder.encode(counter, forKey: "counter")
        aCoder.encode(wishes, forKey: "wishes")
    }

}
