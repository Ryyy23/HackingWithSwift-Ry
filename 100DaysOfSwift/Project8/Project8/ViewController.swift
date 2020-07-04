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
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
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
                // give button temp text
                letterButton.setTitle("WWW", for: .normal)
                // calculate the frame of this button using its column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                // add it to the buttons view
                buttonsView.addSubview(letterButton)
                
                // and also to our letterButtons array
                letterButtons.append(letterButton)
                
            }
        }
        
        cluesLabel.backgroundColor = .red
        answersLabel.backgroundColor = .blue
        buttonsView.backgroundColor = .green
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

