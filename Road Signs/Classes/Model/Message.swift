//
//  Message.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 17.05.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import Foundation

class Message {
    
    var isSender: Bool?
    var text: String?
    var date: Date?
    
    init (text: String, date: Date, isSender: Bool = false){
        
        self.isSender = isSender
        self.text = text
        self.date = date
        
    }
}
