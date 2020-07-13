//
//  ViewController.swift
//  Milestone Project 7-9
//
//  Created by Ryordan Panter on 10/7/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var scoreLabel: UILabel!
    var answerLabel: UILabel!
    var characterButtons = [UIButton]()
    
    let width:CGFloat = 100
    let height:CGFloat = 100
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var wordList = [String]()
    
    var currentWord: String = "Test"
    var usedLetters = [String]()
    var promptWord = "" {
        didSet{
            answerLabel.text = "\(promptWord)"
        }
    }
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.font = UIFont.systemFont(ofSize: 24)
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
//        answerLabel.text = "Test"
        answerLabel.numberOfLines = 1
        answerLabel.textAlignment = .center
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let row1View = UIView()
        row1View.clipsToBounds = true
        row1View.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(row1View)
        
        let row2View = UIView()
        row2View.clipsToBounds = true
        row2View.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(row2View)
        
        let row3View = UIView()
        row3View.clipsToBounds = true
        row3View.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(row3View)

        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 25),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 1000),
            buttonsView.heightAnchor.constraint(equalToConstant: 300),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            row1View.leftAnchor.constraint(equalTo: buttonsView.leftAnchor),
            row1View.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            row1View.widthAnchor.constraint(equalTo: buttonsView.widthAnchor),
            row1View.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 0.333, constant: 0),
            
            
//            row2View.leftAnchor.constraint(equalTo: buttonsView.leftAnchor, constant: 0),
            row2View.topAnchor.constraint(equalTo: row1View.bottomAnchor),
            row2View.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.9),
            row2View.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 0.333, constant: 0),
            row2View.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            
            
            
//            row3View.leftAnchor.constraint(equalTo: buttonsView.leftAnchor),
            row3View.topAnchor.constraint(equalTo: row2View.bottomAnchor),
            row3View.widthAnchor.constraint(equalTo: buttonsView.widthAnchor, multiplier: 0.7),
            row3View.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 0.333, constant: 0),
            row3View.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor)
           
        ])
        
        var i = 10
        
        for row in 0..<3 {
            print(row)
            switch row {
            case 0:
                i = 10
            case 1:
                i = 9
            case 2:
                i = 7
            default:
                return
            }
            for col in 0..<i {
                let characterButton = UIButton(type: .system)
                characterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                
                characterButton.layer.borderWidth = 1
                characterButton.layer.borderColor = UIColor.lightGray.cgColor
                characterButton.layer.backgroundColor = UIColor.white.cgColor
                characterButton.setTitle("#", for: .normal)

//                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                let frame = CGRect(x: CGFloat(col) * width, y: 0, width: width, height: height)
                print(CGFloat(col) * width)
                characterButton.frame = frame
                
                switch row {
                case 0:
                    print(row)
                    print("row 1")
                    row1View.addSubview(characterButton)
                case 1:
                    print(row)
                    print("row 2")
                    row2View.addSubview(characterButton)
                case 2:
                    print(row)
                    print("row 3")
                    row3View.addSubview(characterButton)
                default:
                    print("defualt")
                    return
                }
                
                characterButtons.append(characterButton)
                
                
                characterButton.addTarget(self, action: #selector(characterTapped), for: .touchUpInside)
            }
        }
        
        var az = [String]()
        for char in "abcdefghijklmnopqrstuvwxyz" {
            az.append(String(char))
            
        }
        print(az)
        print("\(az.count) | \(characterButtons.count)"  )
        if az.count == characterButtons.count {
            for i in 0 ..< characterButtons.count {
                characterButtons[i].setTitle(az[i], for: .normal)
            }
        }
        
        
        
        
//       buttonsView.backgroundColor = .purple
        row1View.backgroundColor = .red
        row2View.backgroundColor = .yellow
        row3View.backgroundColor = .green

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    func loadWordFile(){
        if let wordFileURL = Bundle.main.url(forResource: "Aspell-wordlist copy", withExtension: "txt"){
            print(wordFileURL)
            if let wordFileContents = try? String(contentsOf: wordFileURL) {
                let words = wordFileContents.components(separatedBy: "\n")
                wordList = words
                newWord(action: nil)
                print("WORKING")
            }
        }
    }
    func newWord(action: UIAlertAction!){
        let _ = characterButtons.map({$0.isEnabled = true})
        usedLetters.removeAll()
        wordList.shuffle()
        currentWord = wordList.randomElement()!
        checkLetterInWord()
    }
    
    @objc func characterTapped(sender: UIButton) {
        print("working")
        guard let buttonTitle = sender.titleLabel?.text else { return }
        print("Pressed: \(buttonTitle)")
//        sender.isHidden = true
        sender.isEnabled = false
        usedLetters.append(buttonTitle)
        checkLetterInWord()
        

    }
    func loadLevel() {
//        currentWord = "Answer"
        loadWordFile()
        checkLetterInWord()
        
    }

    func checkLetterInWord() {
        var newpromptword = ""
        for letter in currentWord.lowercased() {
            let strLetter = String(letter)
            print(strLetter)

            if usedLetters.contains(strLetter) {
                newpromptword += strLetter
                print("\(strLetter) is a character in \(currentWord.lowercased())")
            } else {
                newpromptword += "?"
                print("\(strLetter) is not a character in  \(currentWord.lowercased())")
                
                }
        }
        promptWord = newpromptword
        print(newpromptword)
        checkWordIsCorrect()
        
    }
    func checkWordIsCorrect() {
        // check if answerlabel.text contains no questions marks
//        guard (answerLabel.text?.contains("?")) == false else { return }
        if currentWord.lowercased() == answerLabel.text?.lowercased() {
            print("winner")
            let ac = UIAlertController(title: "Well done", message: "next round?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: newWord))
            ac.addAction(UIAlertAction(title: "No", style: .default, handler: closeApp))
            
            present(ac, animated: true)
        }
    }
    
    @objc func closeApp(action: UIAlertAction) {
        UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)

    }
    
}

