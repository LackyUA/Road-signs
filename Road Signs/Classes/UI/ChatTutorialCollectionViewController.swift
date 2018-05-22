//
//  ChatTutorialCollectionViewController.swift
//  Road Signs
//
//  Created by Dima Dobrovolskyy on 17.05.18.
//  Copyright © 2018 Artyom Savelyev. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

var mutableArray: NSMutableArray = []

class ChatTutorialCollectionViewController: UICollectionViewController {
    
    var preparedMessages: [Message]?
    var allMessages: [Message]?
    var sendedPreparedMessages = 0
    
    var bottomConstraint: NSLayoutConstraint?
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введіть текст..."
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Надіслати", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        
        self.title = "Chat tutorial"
        
        self.collectionView!.register(ChatTutorialMessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(messageInputContainerView)
        view.addConstrainsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstrainsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = allMessages?.count {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatTutorialMessageCell
    
        cell.messageTextView.text = allMessages?[indexPath.item].text
        
        if let message = allMessages?[indexPath.item], let messageText = message.text {
            let size = CGSize(width: 280, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            
            if !message.isSender! {
                cell.messageTextView.frame = CGRect(x: 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: 8, y: 0, width: estimatedFrame.width + 16 + 8 + 8, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = UIColor.black
            } else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 8 - 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 8, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                cell.messageTextView.textColor = UIColor.white
            }
        }
        
        return cell
    }
}

// Mark: -- Setting cell`s size and CV insets
extension ChatTutorialCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = allMessages?[indexPath.item].text {
            let size = CGSize(width: 280, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFreme = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimatedFreme.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 54, 0)
    }
}

// Mark: -- working with data and different views
extension ChatTutorialCollectionViewController {
    func setupData() {
        preparedMessages = [Message(text: trimmedText("Мене звати Добровольський Дмитро. Я представляю нову компанію по продажу товарів з Китаю. Вам цікаво почути що ми можемо запропонувати? "), date: messageIn(seconds: 0)), Message(text: trimmedText("На даний момент у нас є велика кількість китайських годинників, ціна яких коливається в районі від 300 до 950 гривень. Також є багато чехлів до телефонів різних моделей, починаючи від самсунгів, і закінчуючи айфонами. Також є різний одяг."), date: messageIn(seconds: 0)), Message(text: trimmedText("В мому профілі є посилання на наш сайт, де ви можете ознайомитись з повним переліком товарів."), date: messageIn(seconds: 0)), Message(text: trimmedText("Замовити можна перейшовши на сторінку \"Оформити замовлення\", там є інструкція як оформити замовлення та провести оплату товару."), date: messageIn(seconds: 0)), Message(text: trimmedText(" Дякую що приділили мені увагу. До побачення.  "), date: messageIn(seconds: 0))]
        
        allMessages = [Message(text: trimmedText("Доброго дня."), date: messageIn(seconds: 0))]
        
        allMessages = allMessages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
    }
    
    func messageIn (seconds: Int) -> Date {
        return Date().addingTimeInterval(TimeInterval(seconds))
    }
    
    func trimmedText(_ text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 1)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstrainsWithFormat(format: "H:|-8-[v0][v1(90)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstrainsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstrainsWithFormat(format: "V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstrainsWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstrainsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
    }
    
    func handleKeyboardNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -(keyboardFrame?.height)! : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
            
                }, completion: { (completed) in
                    if isKeyboardShowing {
                        let indexPath = NSIndexPath(item: self.allMessages!.count - 1, section: 0)
                        self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                    }
            })
        }
    }
    
    func handleSend() {
        
        allMessages?.append(Message(text: trimmedText(self.inputTextField.text!), date: Date(), isSender: true))
        
        let indexPath = NSIndexPath(item: allMessages!.count - 1, section: 0)
        collectionView?.insertItems(at: [indexPath as IndexPath])
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        inputTextField.text = nil
        
        if sendedPreparedMessages == preparedMessages?.count {
            sendButton.isEnabled = false
            
            allMessages?.append(Message(text: trimmedText("Більше у мене немає відповідей на Ваші повідомлення.\nP.S. кнопка надсилання неактивна =)"), date: messageIn(seconds: 0)))
            let indexPath = NSIndexPath(item: allMessages!.count - 1, section: 0)
            collectionView?.insertItems(at: [indexPath as IndexPath])
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        } else {
            _ = Timer.scheduledTimer(timeInterval: TimeInterval(arc4random_uniform(2) + 1), target: self, selector: #selector(sendingMessageWithRandomInterval(timer:)), userInfo: nil, repeats: false)
        }
    }
    
    func sendingMessageWithRandomInterval (timer: Timer) {
        allMessages?.append((preparedMessages?[sendedPreparedMessages])!)

        let indexPath = NSIndexPath(item: allMessages!.count - 1, section: 0)
        collectionView?.insertItems(at: [indexPath as IndexPath])
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        
        sendedPreparedMessages += 1
    }
}

// Mark: -- Setting cell and views inside it
class ChatTutorialMessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        
    }
}

// Mark: -- Adding constraints in textual type
extension UIView {
    
    func addConstrainsWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let  key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
    
    func setupViews() {
    }
    
}
