//
//  NameTrainerViewController.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 13.03.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit

class NameTrainerViewController: UIViewController {
    
    var answeredBool = Array<Bool?>(repeating: nil, count: 10)
    var answeredButton = Array<Int?>(repeating: nil, count: 10)
    var nameOfJSONFile = String()
    var signsArray = [Sign]()
    var nameTests = [SignsNamesTest]()
    var switcher = 0
    var timer = Timer()
    var seconds = 120
    
    
    @IBOutlet weak var signImage: UIImageView!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet var switchButtons: [UIButton]!
    
    @IBOutlet var answerStateImage: [UIImageView]!
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        
        if nameTests[switcher].buttonBools[sender.tag] == true {
            sender.backgroundColor = UIColor.green
            answeredBool[switcher] = true
            answerStateImage[switcher].image = UIImage(named: "rightAnswer.png")
            
            AppData.saveInUserDefaults(operation: "+", sender: sender.tag, key: UserDefaultsKeys.nameStatistic, testName: nameTests[switcher])
        } else {
            sender.backgroundColor = UIColor.red
            answeredBool[switcher] = false
            answerStateImage[switcher].image = UIImage(named: "wrongAnswer.png")
            for i in 0..<nameTests[switcher].buttonBools.count {
                if nameTests[switcher].buttonBools[i] == true {
                    answerButtons[i].backgroundColor = UIColor.green
                    
                    AppData.saveInUserDefaults(operation: "-", sender: i, key: UserDefaultsKeys.nameStatistic, testName: nameTests[switcher])
                }
            }
        }
        
        // Saving choosed answer(button).
        answeredButton[switcher] = sender.tag
        
        for button in answerButtons {
            button.isEnabled = false
        }
        
        testFinished(title: "Ви закінчили тест.")
    }
    
    @IBAction func switchButtonTapped(_ sender: UIButton) {

        switch sender.tag {
        case 4:
            if switcher >= 0 {
                switcher -= 1
            }
        case 5:
            if switcher < 9 {
                switcher += 1
            }
        default:
            break
        }
        
        // Showing choosed answer.
        if answeredBool[switcher] != nil {
            for button in answerButtons {
                button.isEnabled = false
            }
            for (index, button) in answerButtons.enumerated() {
                if let id = answeredButton[switcher] {
                    if id == index {
                        if answeredBool[switcher]! == false {
                            button.backgroundColor = UIColor.red
                        } else {
                            button.backgroundColor = UIColor.green
                        }
                    } else {
                        button.backgroundColor = UIColor.lightGray
                    }
                }
            }
        }else {
            for button in answerButtons {
                button.isEnabled = true
            }
            for button in answerButtons {
                button.backgroundColor = UIColor.lightGray
            }
        }
        
        //adding titles for buttons with random location of right answer
        settingButtonsTitles()
        
        signImage?.image = UIImage(named: nameTests[switcher].image)
        if switcher == 0 {
            switchButtons[0].isEnabled = false
        } else if switcher == 9{
            switchButtons[1].isEnabled = false
        } else {
            switchButtons[0].isEnabled = true
            switchButtons[1].isEnabled = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if signsArray.isEmpty {
            nameOfJSONFile = AppData.jsonFileNameArray[AppData.selectedCategoryIndex]
            signsArray = AppData.signsDictionary[nameOfJSONFile]!
        }
        
        runTimer()
        
        for i in 0..<10 {
            signsInit(index: i)
        }
        
        if nameTests.count < 10 {
            for i in nameTests.count - 1..<10 {
                signsInit(index: i)
            }
        }
        
        for i in 0..<10 {
            answerStateImage[i].image = UIImage(named: "answer.png")
        }
        
        //adding titles for buttons with random location of right answer
        settingButtonsTitles()
        
        signImage?.image = UIImage(named: nameTests[switcher].image)
        signImage.translatesAutoresizingMaskIntoConstraints = false
        switchButtons[0].isEnabled = false
        
        for button in answerButtons {
            button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        }
    }
}

extension NameTrainerViewController {
    
    func signsInit(index: Int) {
        if index < signsArray.count {
            nameTests.append(AppData.gettingNameTest(signsArray: signsArray, signNumber: AppData.sortedSignsNamesDictionary(signsArray: signsArray)[index].key))
        } else {
            nameTests.append(AppData.gettingNameTest(signsArray: signsArray, signNumber: AppData.sortedSignsNamesDictionary(signsArray: signsArray)[index - signsArray.count].key))
        }
    }
    
    func testFinished(title: String) {
        var answeredCount = Int()
        var rightAnswers = Int()
        var wrongAnswers = Int()
        for value in answeredBool {
            if value != nil {
                answeredCount += 1
                switch value! {
                case true:
                    rightAnswers += 1
                case false:
                    wrongAnswers += 1
                }
            }
        }
        if answeredCount == 10 {
            alert(title: title, message: "Правильних відповідей: \(rightAnswers)\nНеправильних відповідей: \(wrongAnswers)")
        }
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
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
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        if seconds > 0 {
            seconds -= 1
            if seconds % 60 < 10 {
                self.title = "\((seconds - (seconds % 60))/60):0\(seconds%60)"
            } else {
                self.title = "\((seconds - (seconds % 60))/60):\(seconds%60)"
            }
        } else {
            for button in answerButtons {
                button.isEnabled = false
            }
            self.title = "Час вийшов!"
        }
    }
    
    func settingButtonsTitles() {
        for i in 0..<nameTests[switcher].buttonBools.count {
            if nameTests[switcher].buttonBools[i] == true {
                switch i {
                case 0:
                    answerButtons[0].setTitle(nameTests[switcher].names[i], for: .normal)
                    answerButtons[1].setTitle(nameTests[switcher].names[i + 1], for: .normal)
                    answerButtons[2].setTitle(nameTests[switcher].names[i + 2], for: .normal)
                    answerButtons[3].setTitle(nameTests[switcher].names[i + 3], for: .normal)
                case 1:
                    answerButtons[0].setTitle(nameTests[switcher].names[i - 1], for: .normal)
                    answerButtons[1].setTitle(nameTests[switcher].names[i], for: .normal)
                    answerButtons[2].setTitle(nameTests[switcher].names[i + 1], for: .normal)
                    answerButtons[3].setTitle(nameTests[switcher].names[i + 2], for: .normal)
                case 2:
                    answerButtons[0].setTitle(nameTests[switcher].names[i - 2], for: .normal)
                    answerButtons[1].setTitle(nameTests[switcher].names[i - 1], for: .normal)
                    answerButtons[2].setTitle(nameTests[switcher].names[i], for: .normal)
                    answerButtons[3].setTitle(nameTests[switcher].names[i + 1], for: .normal)
                case 3:
                    answerButtons[0].setTitle(nameTests[switcher].names[i - 3], for: .normal)
                    answerButtons[1].setTitle(nameTests[switcher].names[i - 2], for: .normal)
                    answerButtons[2].setTitle(nameTests[switcher].names[i - 1], for: .normal)
                    answerButtons[3].setTitle(nameTests[switcher].names[i], for: .normal)
                default:
                    break
                }
            }
        }
    }
}
