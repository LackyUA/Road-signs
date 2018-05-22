//
//  TheoryTableViewController.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 09.03.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit

class TheoryTableViewController: UITableViewController {
    
    var signsArray: [Sign] = []
    var signsArrayFiltered: [Sign] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        signsArray = AppData.getCurrentSignsArray()
        signsArrayFiltered = signsArray
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 79.0
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Фільтр", style: .plain, target: self, action: #selector(TheoryTableViewController.filterButtonPressed(sender:)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return signsArrayFiltered.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "theoryCell", for: indexPath) as! TheoryTableViewCell

        cell.theoryName?.text = signsArrayFiltered[indexPath.row].name
        cell.thearyImage?.image = UIImage(named: signsArrayFiltered[indexPath.row].image)
        
        if let loadedValueDictionary = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.valueStatistic) as? [String: Int] {
            if loadedValueDictionary[signsArrayFiltered[indexPath.row].number]! > 0 {
                cell.valueLearnedValue.text = "так \(String(describing: loadedValueDictionary[signsArrayFiltered[indexPath.row].number]!))"
            } else {
                cell.valueLearnedValue.text = "ні \(String(describing: loadedValueDictionary[signsArrayFiltered[indexPath.row].number]!))"
            }
        }
        
        if let loadedValueDictionary = UserDefaults.standard.dictionary(forKey:UserDefaultsKeys.nameStatistic) as? [String: Int] {
            if loadedValueDictionary[signsArrayFiltered[indexPath.row].number]! > 0 {
                cell.nameLearnedValue.text = "так \(String(describing: loadedValueDictionary[signsArrayFiltered[indexPath.row].number]!))"
            } else {
                cell.nameLearnedValue.text = "ні \(String(describing: loadedValueDictionary[signsArrayFiltered[indexPath.row].number]!))"
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TheoryDetailsSegue" {
            let DC = segue.destination as! TheoryDetailsTableViewController
            if let IndexPath = tableView.indexPathForSelectedRow{
                DC.signs = signsArray[IndexPath.row]
            }
        }
    }
}

extension TheoryTableViewController {
    
    func filterButtonPressed(sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Фільтр", message: "Оберіть критерій, по котрому необхідно відфільтрувати знаки.", preferredStyle: .actionSheet)
        
        let allSignsAction = UIAlertAction(title: "Всі знаки", style: .default) {
            UIAlertAction in
            self.signsArrayFiltered = self.signsArray
            self.tableView.reloadData()
        }
        
        let learnedNameAction = UIAlertAction(title: "Вивчено назву", style: .default) {
            UIAlertAction in
            self.signsArrayFiltered = self.signsArray
            if let loadedValueDictionary = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.nameStatistic) as? [String: Int] {
                for i in (self.signsArrayFiltered.startIndex..<self.signsArrayFiltered.endIndex).reversed() {
                    if loadedValueDictionary[self.signsArrayFiltered[i].number]! <= 0 {
                        self.signsArrayFiltered.remove(at: i)
                    }
                }
            }
            self.tableView.reloadData()
        }
        
        let unlearnedNameAction = UIAlertAction(title: "Не вивчено назву", style: .default) {
            UIAlertAction in
            self.signsArrayFiltered = self.signsArray
            if let loadedValueDictionary = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.nameStatistic) as? [String: Int] {
                for i in (self.signsArrayFiltered.startIndex..<self.signsArrayFiltered.endIndex).reversed() {
                    if loadedValueDictionary[self.signsArrayFiltered[i].number]! > 0 {
                        self.signsArrayFiltered.remove(at: i)
                    }
                }
            }
            self.tableView.reloadData()
        }
        
        let learnedTheoryAction = UIAlertAction(title: "Вивчено значення", style: .default) {
            UIAlertAction in
            self.signsArrayFiltered = self.signsArray
            if let loadedValueDictionary = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.valueStatistic) as? [String: Int] {
                for i in (self.signsArrayFiltered.startIndex..<self.signsArrayFiltered.endIndex).reversed() {
                    if loadedValueDictionary[self.signsArrayFiltered[i].number]! <= 0 {
                        self.signsArrayFiltered.remove(at: i)
                    }
                }
            }
            self.tableView.reloadData()
        }
        
        let unlearnedTheoryAction = UIAlertAction(title: "Не вивчено значення", style: .default) {
            UIAlertAction in
            self.signsArrayFiltered = self.signsArray
            if let loadedValueDictionary = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.valueStatistic) as? [String: Int] {
                for i in (self.signsArrayFiltered.startIndex..<self.signsArrayFiltered.endIndex).reversed() {
                    if loadedValueDictionary[self.signsArrayFiltered[i].number]! > 0 {
                        self.signsArrayFiltered.remove(at: i)
                    }
                }
            }
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Закрити", style: .cancel) {
            UIAlertAction in
        }
        
        alert.addAction(allSignsAction)
        alert.addAction(learnedNameAction)
        alert.addAction(unlearnedNameAction)
        alert.addAction(learnedTheoryAction)
        alert.addAction(unlearnedTheoryAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion:  nil)
        }
    }
    
}
