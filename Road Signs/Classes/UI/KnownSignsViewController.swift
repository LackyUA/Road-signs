//
//  KnownSignsViewController.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 01.05.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit

class KnownSignsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var signsCollectionView: UICollectionView!
    
    var signs = [Sign]()
    fileprivate var selectedSigns = [Sign]()
    
    fileprivate var sectionsArray = [
            "1. Попереджувальні знаки",
            "2. Знаки пріоритету",
            "3. Заборонні знаки",
            "4. Наказові знаки",
            "5. Інформаційно-вказівні знаки",
            "6. Знаки сервісу",
            "7. Таблички до дорожніх знаків",
            "8. Горизонтальна розмітка",
            "9. Вертикальна розмітка"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = "Виберіть 10 знаків, які ви знаєте або які вам знайомі. Коли такі знаки закінчаться, виберіть знаки, які вам подобаються.(0)"
       
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Тест", style: .plain, target: self, action: #selector(KnownSignsViewController.startTestButtonPressed(sender:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return AppData.jsonFileNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppData.signsDictionary[AppData.jsonFileNameArray[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "KnownSignsCollectionReusableView", for: indexPath) as! KnownSignsCollectionReusableView
            headerView.sectionLabel.text = sectionsArray[(indexPath as NSIndexPath).section]
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KnownSignsCollectionViewCell", for: indexPath) as! KnownSignsCollectionViewCell
        
        let sign = signForIndexPath(indexPath: indexPath)
        cell.displayContent(image: sign.image)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedSigns.count < 10 {
            let sign = signForIndexPath(indexPath: indexPath)
            selectedSigns.append(sign)
            updateSelectedSignsCount()
            
            if selectedSigns.count == 10 {
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
            
        } else {
            let alert = UIAlertController(title: "Вибрано 10 знаків.", message: "Ви вибрали 10 знаків, для того щоб перейти до тестування натисніть кнопку \"Тест\".", preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel) {
                UIAlertAction in
                if let nvc = self.navigationController {
                    nvc.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion:  nil)
        }
        
    }
    
    func updateSelectedSignsCount() {
        descriptionLabel.text = "Виберіть 10 знаків, які ви знаєте або які вам знайомі. Коли такі знаки закінчаться, виберіть знаки, які вам подобаються.(\(selectedSigns.count))"
    }
    
    func signForIndexPath(indexPath: IndexPath) -> Sign {
        signs = AppData.signsDictionary[AppData.jsonFileNameArray[indexPath.section]]!
        return signs[(indexPath as NSIndexPath).row]
    }

}

extension KnownSignsViewController {
    func startTestButtonPressed(sender: UIBarButtonItem) {
        descriptionLabel.text = "Виберіть 10 знаків, які ви знаєте або які вам знайомі. Коли такі знаки закінчаться, виберіть знаки, які вам подобаються.(0)"
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NameTrainerViewController") as! NameTrainerViewController
        controller.signsArray = selectedSigns
        navigationController?.pushViewController(controller, animated: true)
        
        //refreshing data
        selectedSigns = [Sign]()
    }
}
