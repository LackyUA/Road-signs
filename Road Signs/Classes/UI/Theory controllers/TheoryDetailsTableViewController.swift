//
//  TheoryDetailsTableViewController.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 11.03.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit

class TheoryDetailsTableViewController: UITableViewController {

    var signs = Sign()
    
    @IBOutlet weak var signImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signImage.image = UIImage(named: signs.image)
        DispatchQueue.main.async {
            self.signImage.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 110.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TheoryDetailsTableViewCell

        cell.signName?.text = signs.name

        // TODO: Выравнивание по центру сделать в Storyboard
        cell.signName?.textAlignment = NSTextAlignment.center
        cell.signDescription?.text = signs.description
        cell.signDescription?.textAlignment = NSTextAlignment.justified
        
        return cell
    }
}
