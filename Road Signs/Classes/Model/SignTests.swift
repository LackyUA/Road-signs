//
//  SignsTest.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 22.03.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import Foundation

class SignTests {
    
    var question = ""
    var image = ""
    var number = ""
    var answers = [""]
    var name = ""
    
    init (jsonDict: [String : Any]) {
        if
            let number = jsonDict["number"] as? String,
            let question = jsonDict["question"] as? String,
            let image = jsonDict["image"] as? String,
            let answers = jsonDict["answers"] as? [String],
            let name = jsonDict["name"] as? String {
            
            self.question = question
            self.image = image
            self.number = number
            self.answers = answers
            self.name = name
        }
    }
    
    init (){
    }
}
