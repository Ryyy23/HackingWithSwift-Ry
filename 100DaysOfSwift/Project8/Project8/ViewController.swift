//
//  ViewController.swift
//  Project8
//
//  Created by Ryordan Panter on 4/7/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        // property observer. updates score label.text on value change
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var correctAnswerScore = 0 {
        didSet {
            if correctAnswerScore == 7 {
                let ac = UIAlertController(title: "Well done!", message: "are you ready for next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            // pin the top of the score label to the top of our layout margin
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            // pin the trailing edge of our score label to the leading edge of our layout margin
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // pin the leading ehde of the clues label to the leading edge out out layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            // also pin the top of the answer label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // make the answer lable stick to the trailing edge of our layout margins, 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            // make the answer label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            // make the answer label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            // make the currentanswer textfeild horizontally center with the view
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // make currentanswer textfeild 50% wide
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            // place currentanswer textfeild below clues label with 20 points spacing
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            // set submit buttom to the bottom of currentAnswer TextFeild
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            // make submit buttom horizontally center with the view - 100 points
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            // make submit button height 44 points
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            // make clear buttom horizontally center with the view - 100 points
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            // make clear buttom vertically align with submit button
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            // make clear button height 44 points
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            // buttonView width 750
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            // butttonView height 320
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            // buttonView centered horizontally
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // buttonView set its top anchor to be the bottom of the submit button, plus 20 points to add a little spacing
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            //pin buttonView it to the bottom of our layout margins, -20 so that it doesn’t run quite to the edge.
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        // set values for the width and height of each button
        let width = 150
        let height = 80
        
        // 4 rows
        for row in 0..<4 {
            // 5 collums
            for col in 0..<5 {
                // create a new button and give it a big font size
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                // button border
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                // give button temp text
                letterButton.setTitle("WWW", for: .normal)
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                // and also to our letterButtons array
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
            }
        }
        
//        cluesLabel.backgroundColor = .red
//        answersLabel.backgroundColor = .blue
//        buttonsView.backgroundColor = .green
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()    }
    
    @objc func letterTapped(_ sender: UIButton){
        // safely unwrap button title
        guard let buttonTitle = sender.titleLabel?.text else { return }
        // appends button title to the player's current answer
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        //appends button to the activatedButtons array
        activatedButtons.append(sender)
        // hides button when tapped
        sender.isHidden = true
        
    }
    
    @objc func submitTapped(_ sender: UIButton){
        
        // safely unwrap currentAnswer.text
        guard let answerText = currentAnswer.text else { return }
        
        // search through solutions array for an item and if it finds it, tell us it's position
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            print(solutionPosition)
            // remove all activatedButtons
            activatedButtons.removeAll()
            
            // split answerlabel text by new line (/n)
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            print(splitAnswers)
            // replace answerlabel text with answet text at it's correct position within the array
            splitAnswers?[solutionPosition] = answerText
            print(answerText)
            // join up answerlabels into array with /n (new line for each element
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            print(answersLabel.text)
            // set answer.text to blank
            currentAnswer.text = ""
            score += 1
            correctAnswerScore += 1
            
            // if score devides between 7 equally
//            var hiddenBtnCount = 0
//            for btn in letterButtons {
//                if btn.isHidden == true {
//                    hiddenBtnCount += 1
//                    //print("button clicked")
//                }
//                //print("total: \(hiddenBtnCount)")
//                if hiddenBtnCount == 20 {
//                    //print("working")
//                    let ac = UIAlertController(title: "Well done!", message: "are you ready for next level", preferredStyle: .alert)
//                    ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
//                    present(ac, animated: true)
//                }
//
//            }
//            if score % 7 == 0 {
//                let ac = UIAlertController(title: "Well done!", message: "are you ready for next level", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
//                present(ac, animated: true)
//            }
        } else {
            let ac = UIAlertController(title: "Wrong Answer", message: "\(currentAnswer.text ?? "error") is not the correct anwser", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            score -= 1
            
        }
        
    }
    
    @objc func clearTapped(_ sender: UIButton){
        // reset currentAnswer text to empty
        currentAnswer.text = ""
        
        // reset all btns in activatedButtons
        for btn in activatedButtons {
            btn.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    func loadLevel() {
        print("load level")
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        // declare file variable and get file named level(1?2?).txt from app bundle
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            //check text is strings (eg: text)
            if let levelContents = try? String(contentsOf: levelFileURL) {
                //split text into array by breaking on /n (new line)
                var lines = levelContents.components(separatedBy: "\n")
                // shuffle lines
                lines.shuffle()
                
                // enumerated() will place the item into the line variable and its position into the index variable
                // enumeration tells where each variable in the array is
                for (index, line) in lines.enumerated() {
                    //HA|UNT|ED: Ghosts in residence
                    // first part HA|UNT|ED
                    //:
                    // second part Ghosts in residence
                    let parts = line.components(separatedBy: ": ")
                    //HA|UNT|ED
                    let answer = parts[0]
                    //Ghosts in residence
                    let clue = parts[1]
                    // clueString =  1. Ghosts in residence/n
                    clueString += "\(index + 1). \(clue)\n"
                    
                    // removes | from string eg: HA|UNT|ED -> HAUNTED
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    // count lengeth of word HAUNTED 7 letters
                    solutionString += "\(solutionWord.count) letters\n"
                    // add solutionWord into solutions array
                    solutions.append(solutionWord)
                    
                    // turn string HA|UNT|ED into array of three elements 1.HA  2.UNT 3.ED
                    let bits = answer.components(separatedBy: "|")
                    // add all three bits into letterBits
                    letterBits += bits
                }
            }
        }
        // removes white space and new lines (/n)
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        
        if letterBits.count == letterButtons.count {
            print("test")
            // loop through letterButtons.count
            for i in 0 ..< letterButtons.count {
                // set Title foreach button with each letter bit per button 1 gets letterbits 1
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp(action: UIAlertAction){
        level += 1
        correctAnswerScore = 0
        
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }


}

