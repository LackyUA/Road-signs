//
//  KnownSignsCollectionViewCell.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 01.05.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit

class KnownSignsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var signImage: UIImageView!
    
    func displayContent (image: String) {
        signImage.image = UIImage(named: image)
    }
    
}
