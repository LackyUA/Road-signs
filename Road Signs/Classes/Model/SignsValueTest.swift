//
//  SignsValueTest.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 25.04.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import Foundation

class SignsValueTest {
    
    var number: String = ""
    var image = ""
    var question = ""
    var answers: [String] = []
    var randomNumber: Int = 0
    
    
    init (number: String, image: String, question: String, answers: [String], randomNumber: Int){
        
        self.number = number
        self.image = image
        self.question = question
        self.answers = answers
        self.randomNumber = randomNumber
    }
    
}
