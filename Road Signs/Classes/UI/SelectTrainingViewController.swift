//
//  SelectTrainingViewController.swift
//  Road Signs
//
//  Created by Artyom Savelyev on 10.01.2018.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit

class SelectTrainingViewController: UIViewController {
    
    fileprivate var cellsData = [
        [
            "name": "Теорія",
            "detail": "",
        ],
        [
            "name": "Тренажер 'Назви'",
            "detail": "Здаючи іспит водіння, ви маєте називати назви знаків інспектору. Цей тренажер допоможе вам вивчити назви знаків"
        ],
        [
            "name": "Тренажер 'Значення'",
            "detail": ""
        ],
        [
            "name": "Тренажер 'Знайомі знаки'",
            "detail": ""
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SelectTrainingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTrainingCell") else {
            return UITableViewCell()
        }
        
        let data = cellsData[indexPath.row]

        cell.textLabel?.text = data["name"]
        cell.detailTextLabel?.text = data["detail"]
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            goToViewController(with: "TheoryTableViewController")
        case 1:
            goToViewController(with: "NameTrainerViewController")
        case 2:
            goToViewController(with: "QustionsTrainerViewController")
        case 3:
            goToViewController(with: "KnownSignsViewController")
            
        default:
            break
        }
    }
}


//Mark : - Functions

extension SelectTrainingViewController {
 
    fileprivate func goToViewController(with name: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: name)
        navigationController?.pushViewController(controller, animated: true)
    }
}
