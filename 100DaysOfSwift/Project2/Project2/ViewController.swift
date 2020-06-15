//
//  ViewController.swift
//  Project2
//
//  Created by Ryordan Panter on 13/6/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var howManyQuestionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion(action: nil)
        
    }
    
    func askQuestion(action: UIAlertAction!) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = "Select: \(countries[correctAnswer].uppercased()) + Current Score: \(score)"
    }
    
    func restartGame(action: UIAlertAction!) {
        score = 0
        correctAnswer = 0
        howManyQuestionsAsked = 0
        
        askQuestion(action: nil)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
            if sender.tag == correctAnswer {
                title = "Correct"
                score += 1
                
            } else {
                title = "Wrong! Correct Flag is: \(countries[correctAnswer].uppercased())"
                score -= 1
                
            }
            howManyQuestionsAsked += 1
            print(howManyQuestionsAsked)
            
        if howManyQuestionsAsked <= 9 {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        } else {
            let youWonAC = UIAlertController(title: "You Won", message: "Your Final Score is: \(score)", preferredStyle: .alert)
            youWonAC.addAction(UIAlertAction(title: "Restart", style: .default, handler: restartGame))
            present(youWonAC, animated: true)
        }
            
    }
    
}

