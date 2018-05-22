//
//  Signs.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 09.03.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import Foundation

class Sign {
    
    var name = ""
    var image = ""
    var number = ""
    var description = ""

    init (jsonDict: [String : Any]) {

        if
            let name = jsonDict["name"] as? String,
            let number = jsonDict["number"] as? String,
            let description = jsonDict["description"] as? String {
            
            self.name = name
            self.number = number
            self.description = description
            self.image = number + ".jpeg"
        }
    }
    
    init() {        
    }
}

