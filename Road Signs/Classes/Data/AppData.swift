//
//  ApplicationData.swift
//  Road Signs
//
//  Created by Artyom Savelyev on 10.01.2018.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit


enum UserDefaultsKeys {
    static let valueStatistic = "valueStatistic"
    static let nameStatistic = "nameStatistic"
}


class AppData: NSObject {

    fileprivate static let instance = AppData()

    static var signNameNumbers = [String]()
    static var nameTests = [SignsNamesTest]()
    static var testNumberArray = [String]()
    static var signNameArray = [String]()
    static var buttonBoolArray = [false, false, false, false]
    static var randomNumber = Int()
    static var signImage = String()
    
    static var testArray = [SignTests]()
    
    static var signsDictionary: [String: [Sign]] = [:]
    static var signsTestDictionary: [String: [SignTests]] = [:]

    static var signsTestArray: [SignTests] = []
    static var statistic: [String: Int] = [:]
    
    static var selectedCategoryIndex = 0
    
    static var jsonFileNameArray = [
        "WarningSigns",
        "PrioritySigns",
        "ProhibitionSigns",
        "OrderSigns",
        "InformationSigns",
        "ServiceSigns",
        "TabletsForRoadSigns",
        "HorizontalMarkup",
        "VerticalMarcup"
        ]
    
    
    static func getCurrentSignsArray() -> [Sign] {
        let key = jsonFileNameArray[selectedCategoryIndex]

        if let array = signsDictionary[key] {
            return array
        }
        
        return []
    }
}

// Mark: - Making random signs names list

extension AppData {
    static func gettingNameTest(signsArray: [Sign], signNumber: String) -> SignsNamesTest {
        
        testNumberArray = [String]()
        signNameArray = [String]()
        signNameNumbers = [String]()
        buttonBoolArray = [false, false, false, false]

        // adding wrong answers
        signNameNumbers.append(signNumber)
        for _ in 0...2 {
            randomNumber = Int(arc4random_uniform(UInt32(signsArray.count)))
            getName(signsArray: signsArray)
        }
        
        //adding right answer
        for (index, sign) in signsArray.enumerated() {
            if sign.number == signNumber {
                let rn = Int(arc4random_uniform(UInt32(signNameArray.count + 1)))
                signNameArray.insert(signsArray[index].name, at: rn)
                testNumberArray.insert(signsArray[index].number, at: rn)
                signImage = signsArray[index].image
                buttonBoolArray[rn] = true
            }
        }
        
        return SignsNamesTest(numbers: testNumberArray, image: signImage, names: signNameArray, buttonBools: buttonBoolArray)
    }
    
    // adding random number to answers
    static func getName(signsArray: [Sign]) {
        var k = Int()
        
        for _ in 0..<10 {
            k = checkSameNumbers(signsArray: signsArray)
            
            if k == signNameNumbers.count {
                signNameNumbers.append(signsArray[randomNumber].number)
                choosingRandomSign(id: randomNumber, signsArray: signsArray)
                break
            }
        }
    }
    
    // searching same numbers
    static func checkSameNumbers(signsArray: [Sign]) -> Int {
        var k = Int()
        for number in signNameNumbers {
            if number == signsArray[randomNumber].number {
                randomNumber = Int(arc4random_uniform(UInt32(signsArray.count)))
                break
            } else {
                k += 1
            }
        }
        return k
    }
    
    // adding answers to array
    static func choosingRandomSign(id: Int, signsArray: [Sign]) {
        signNameArray.append(signsArray[id].name)
        testNumberArray.append(signsArray[id].number)
    }
    
    // sorting dictionary for getting priority
    static func sortedSignsNamesDictionary(signsArray: [Sign]) -> [(key: String, value: Int)] {
        var dict = [String: Int]()
        for value in signsArray {
            dict[value.number] = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.nameStatistic)?[value.number] as! Int?
        }
        return dict.sorted(by: {$0.value < $1.value})
    }
}

// Mark: - Making random signs value list

extension AppData {
    static func gettingValueTest(testArray: [SignTests], signNumber: String) -> SignsValueTest {
        for (index, value) in testArray.enumerated() {
            if value.number == signNumber {
                return SignsValueTest(number: testArray[index].number, image: testArray[index].image, question: testArray[index].question, answers: testArray[index].answers, randomNumber: Int(arc4random_uniform(UInt32(4))))
            }
        }
        
        return SignsValueTest(number: "", image: "", question: "", answers: [""], randomNumber: 0)
    }
    
    // sorting dictionary for getting priority
    static func sortedSignsValueDictionary(testsArray: [SignTests]) -> [(key: String, value: Int)] {
        var dict = [String: Int]()
        for value in testsArray {
            dict[value.number] = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.valueStatistic)?[value.number] as! Int?
        }
        return dict.sorted(by: {$0.value < $1.value})
    }
}

// Mark: - Save data in UserDefaults

extension AppData {
    static func saveInUserDefaults(operation: String, sender: Int, key: String, testName: SignsNamesTest) {
        if var loadedValueDictionary = UserDefaults.standard.dictionary(forKey: key) as? [String: Int] {
            if operation == "+" {
                loadedValueDictionary[testName.numbers[sender]]! += 1
            } else if operation == "-"{
                loadedValueDictionary[testName.numbers[sender]]! -= 1
            }
            UserDefaults.standard.set(loadedValueDictionary, forKey: key)
        }
    }
}

// Mark: - Load data

extension AppData {
    
    static func loadData() {
        
        loadSigns()
        loadSignTests()
        
        if UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.valueStatistic) == nil {
            UserDefaults.standard.set(statistic, forKey: UserDefaultsKeys.valueStatistic)
        }
        if UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.nameStatistic) == nil {
            UserDefaults.standard.set(statistic, forKey: UserDefaultsKeys.nameStatistic)
        }
    }
    
    private static func loadSigns() {
        for fileName in jsonFileNameArray {
            var categoryArray: [Sign] = []
            
            guard let jsonArray = readJsonFromFile(fileName) as? [[String: Any]] else {
                print ("Error. Can't parse json array")
                return
            }
            
            for dict in jsonArray {
                let sign = Sign(jsonDict: dict)
                categoryArray.append(sign)
                statistic[sign.number] = 0
            }
            signsDictionary[fileName] = categoryArray
        }
    }
    
    private static func loadSignTests() {
        for fileName in jsonFileNameArray {
            var categoryArray: [SignTests] = []
            
            guard let jsonArray = readJsonFromFile(fileName + "Test") as? [[String: Any]] else {
                print ("Error. Can't parse json array")
                return
            }
            
            for dict in jsonArray {
                let test = SignTests(jsonDict: dict)
                categoryArray.append(test)
            }
            
            signsTestDictionary[fileName + "Test"] = categoryArray
        }
    }
    
    static func readJsonFromFile(_ fileName: String) -> Any {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                return json
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return 0
    }

    
}
