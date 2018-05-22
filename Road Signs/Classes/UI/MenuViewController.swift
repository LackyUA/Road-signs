//
//  MenuViewController.swift
//  Road Signs
//
//  Created by Artyom Savelyev on 10.01.2018.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var dataArray = [
        [
            "1. Попереджувальні знаки",
            "2. Знаки пріоритету",
            "3. Заборонні знаки",
            "4. Наказові знаки",
            "5. Інформаційно-вказівні знаки",
            "6. Знаки сервісу",
            "7. Таблички до дорожніх знаків"
        ],
        [
            "8. Горизонтальна розмітка",
            "9. Вертикальна розмітка"
        ]
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if segue.identifier == "SelectTrainingSegue" {
            AppData.selectedCategoryIndex = calculateSelectedCategoryIndex()
        }
    }
    
    func calculateSelectedCategoryIndex() -> Int {
        if let indexPath = tableView.indexPathForSelectedRow {
            let array = dataArray[0]
            let index = indexPath.section*array.count + indexPath.row
            return index
        }

        return 0
    }
}


// Mark: - UITableView DataSource ande Delegate

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = dataArray[section]
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") else {
            return UITableViewCell()
        }

        let array = dataArray[indexPath.section]
        cell.textLabel?.text = array[indexPath.row]
        cell.detailTextLabel?.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Дорожні знаки"
        case 1:
            return "Дорожня розмітка"
        default:
            return ""
        }
    }    
}
