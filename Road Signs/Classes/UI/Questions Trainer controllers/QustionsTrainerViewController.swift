//
//  QustionsTrainerViewController.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 22.03.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit
import CoreData

class QustionsTrainerViewController: UIViewController {
    
    var testArray = [SignTests]()
    
    var answeredBool = Array<Bool?>(repeating: nil, count: 10)
    var answeredButton = Array<Int?>(repeating: nil, count: 10)
    var buttonBoolArray = Array<Bool>(repeating: false, count: 4)
    var tests = [SignsValueTest]()
    
    var switcher = 0
    var timer = Timer()
    var seconds = 120
    
    @IBOutlet weak var questionTest: UILabel!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet var answerButtons: [UIButton]!
    @IBOutlet var answerSwitchButtons: [UIButton]!
    
    @IBOutlet var answerStateImage: [UIImageView]!
    
    
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        
        for button in answerButtons {
            button.isEnabled = false
        }
        
        if buttonBoolArray[sender.tag] == true {
            sender.backgroundColor = UIColor.green
            answerStateImage[switcher].image = UIImage(named: "rightAnswer.png")
            answeredBool[switcher] = true
            if var loadedValueDictionary = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.valueStatistic) as? [String: Int] {
                
                loadedValueDictionary[self.tests[switcher].number]! += 1
                UserDefaults.standard.set(loadedValueDictionary, forKey: UserDefaultsKeys.valueStatistic)
            }
            
        } else {
            sender.backgroundColor = UIColor.red
            answerStateImage[switcher].image = UIImage(named: "wrongAnswer.png")
            answeredBool[switcher] = false
            if var loadedValueDictionary = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.valueStatistic) as? [String: Int] {
            
                loadedValueDictionary[self.tests[switcher].number]! -= 1
                UserDefaults.standard.set(loadedValueDictionary, forKey: UserDefaultsKeys.valueStatistic)
            }
        
            for i in 0..<buttonBoolArray.count {
                if buttonBoolArray[i] == true {
                    switch i {
                    case 0:
                        answerButtons[0].backgroundColor = UIColor.green
                    case 1:
                        answerButtons[1].backgroundColor = UIColor.green
                    case 2:
                        answerButtons[2].backgroundColor = UIColor.green
                    case 3:
                        answerButtons[3].backgroundColor = UIColor.green
                    default:
                        break
                    }
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
    
    @IBAction func answerSwitchButtonTapped(_ sender: UIButton) {
        
        buttonBoolArray = Array<Bool>(repeating: false, count: 4)
        
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
        titleForButtons(rnb: tests[switcher].randomNumber)
        
        Image?.image = UIImage(named: tests[switcher].image)
        questionTest?.text = tests[switcher].question
        if switcher == 0 {
            answerSwitchButtons[0].isEnabled = false
        } else if switcher == 9{
            answerSwitchButtons[1].isEnabled = false
        } else {
            answerSwitchButtons[0].isEnabled = true
            answerSwitchButtons[1].isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBoolArray = Array<Bool>(repeating: false, count: 4)
        
        runTimer()
        
        testArray = AppData.signsTestDictionary[AppData.jsonFileNameArray[AppData.selectedCategoryIndex] + "Test"]!
        
        for i in 0..<10 {
            if i < testArray.count {
                tests.append(AppData.gettingValueTest(testArray: testArray, signNumber: AppData.sortedSignsValueDictionary(testsArray: testArray)[i].key))
            } else {
                tests.append(AppData.gettingValueTest(testArray: testArray, signNumber: AppData.sortedSignsValueDictionary(testsArray: testArray)[i - testArray.count].key))
            }
        }
        
        //set random titles for buttons
        titleForButtons(rnb: tests[switcher].randomNumber)
        
        questionTest?.text = tests[switcher].question
        Image?.image = UIImage(named: tests[switcher].image)
        Image.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<10 {
            answerStateImage[i].image = UIImage(named: "answer.png")
        }
        
        for button in answerButtons {
            button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        }
        
    }
}

extension QustionsTrainerViewController {
    
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
    
    func titleForButtons(rnb: Int) {
        switch rnb {
        case 0:
            answerButtons[0].setTitle(tests[switcher].answers[rnb], for: .normal)
            answerButtons[1].setTitle(tests[switcher].answers[rnb + 1], for: .normal)
            answerButtons[2].setTitle(tests[switcher].answers[rnb + 2], for: .normal)
            answerButtons[3].setTitle(tests[switcher].answers[rnb + 3], for: .normal)
            buttonBoolArray[rnb] = true
        case 1:
            answerButtons[0].setTitle(tests[switcher].answers[rnb], for: .normal)
            answerButtons[1].setTitle(tests[switcher].answers[rnb - 1], for: .normal)
            answerButtons[2].setTitle(tests[switcher].answers[rnb + 1], for: .normal)
            answerButtons[3].setTitle(tests[switcher].answers[rnb + 2], for: .normal)
            buttonBoolArray[rnb] = true
        case 2:
            answerButtons[0].setTitle(tests[switcher].answers[rnb], for: .normal)
            answerButtons[1].setTitle(tests[switcher].answers[rnb - 1], for: .normal)
            answerButtons[2].setTitle(tests[switcher].answers[rnb - 2], for: .normal)
            answerButtons[3].setTitle(tests[switcher].answers[rnb + 1], for: .normal)
            buttonBoolArray[rnb] = true
        case 3:
            answerButtons[0].setTitle(tests[switcher].answers[rnb], for: .normal)
            answerButtons[1].setTitle(tests[switcher].answers[rnb - 1], for: .normal)
            answerButtons[2].setTitle(tests[switcher].answers[rnb - 2], for: .normal)
            answerButtons[3].setTitle(tests[switcher].answers[rnb - 3], for: .normal)
            buttonBoolArray[rnb] = true
        default:
            break
        }
    }
}
