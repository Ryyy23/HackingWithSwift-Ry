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
    var highScore = 0
    var correctAnswer = 0
    var howManyQuestionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let defaults = UserDefaults.standard
//        let savedHighScore = defaults.integer(forKey: "highScore")
//        highScore = savedHighScore
        
        let defaults = UserDefaults.standard
        let savedHighScore = defaults.integer(forKey: "highScore")
        highScore = savedHighScore
        print("SavedHighScore: \(savedHighScore)")
        print("HighScore: \(highScore)")
        
//        let defaults = UserDefaults.standard
        
//        if let savedHighScore = defaults.integer(forKey: "highScore") {
//            let jsonDecoder = JSONDecoder()
//            do {
//                highScore = try jsonDecoder.decode(highScore?, from: savedHighScore)
//            } catch {
//                print("Failed to load highScore")
//            }
//
//        }
        
        // adding countries entries into countries array
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        // setting border for each button
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // setting border color for each flag button
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion(action: nil)
    }
    
    func askQuestion(action: UIAlertAction!) {
        // shuffling countries in countries array
        countries.shuffle()
        
        // random number generator between 0 to 2 eg: 1,2,3
        correctAnswer = Int.random(in: 0...2)
        
        //setting 'flag' images
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        // App title in nav bar
        
        title = "Select:  \(countries[correctAnswer].uppercased()) |  Current Score: \(score) |  Current Round: \(howManyQuestionsAsked) |  High Score: \(highScore)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "score", style: .plain, target: self, action: #selector(fetchScore))
    }
    
    // reset all scores
    func restartGame(action: UIAlertAction!) {
        score = 0
        correctAnswer = 0
        howManyQuestionsAsked = 0
        askQuestion(action: nil)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        // button animation
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        })
        
        // correct answer
            if sender.tag == correctAnswer {
                title = "Correct"
                score += 1
        // wrong answer
            } else {
                title = "Wrong! Correct Flag is: \(countries[correctAnswer].uppercased())"
                score -= 1
            }
        // counting how many questions have been answered
            howManyQuestionsAsked += 1
            print(howManyQuestionsAsked)
            
        // UIAlert for under 10th questions answered
        if howManyQuestionsAsked <= 9 {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
        // UIAlert for 10th questions answered
        else {
//            var acMessage = String()
            let message = saveHighScore()
            let youWonAC = UIAlertController(title: "You Won", message: message , preferredStyle: .alert)
            youWonAC.addAction(UIAlertAction(title: "Restart", style: .default, handler: restartGame))
            present(youWonAC, animated: true)
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            
        }
    }
    // fetch score for score button in top right nav bar.
    @objc func fetchScore() {
        print("button working")
        print("Your Current score: \(score)")
        
        let currentScoreAC = UIAlertController(title: "Current Score", message: "\(score)", preferredStyle: .alert)
        currentScoreAC.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(currentScoreAC, animated: true)
    }
    
    func saveHighScore() -> String {
        var newMessage = String()
        // check of current game score is higher than savedhighscore
        if score >= highScore {
            // set new high score
            let newHighScore = score
            print("setting highscore:\(newHighScore)")
            let defaults = UserDefaults.standard
            // saved new high score to userDefaults
            defaults.setValue(newHighScore, forKey: "highScore")
            newMessage = ("You won! Score: \(score), Your new highscore is: \(newHighScore)!")
            
        } else {
            let currentHighScore = highScore
            newMessage = ("You won! Score:  \(score), Try betting your current highscore: \(currentHighScore)!!")
            print("didn't reach new highscore")
        }
        return newMessage
    }
}

