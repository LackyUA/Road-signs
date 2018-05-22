//
//  TheoryDetailsTableViewCell.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 11.03.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit

class TheoryDetailsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var signName: UILabel!
    @IBOutlet weak var signDescription: UILabel!

    
    func configure(_ sign: Sign) {
        
        // TOOD: сюда передать знак и выполнить заполнение данных в этом месте
    }
}
