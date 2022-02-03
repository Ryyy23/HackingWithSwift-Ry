//
//  ViewController.swift
//  Project2
//
//  Created by Ryordan Panter on 13/6/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
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
        
        registerLocalNotifications()
        scheduleLocalNotifications()
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
        scheduleLocalNotifications()
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
    
    func registerLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
    
    func scheduleLocalNotifications() {
        
        registerCategories()
        
        let center = UNUserNotificationCenter.current()
        
        center.removeAllPendingNotificationRequests()
        
        let day1 = UNMutableNotificationContent()
        day1.title = "Play again Day 1?"
        day1.body = "Smash out a new highscore!"
        day1.categoryIdentifier = "reminder"
        day1.sound = UNNotificationSound.default
        
        let day2 = UNMutableNotificationContent()
        day2.title = "Play again Day 2?"
        day2.body = "Smash out a new highscore!"
        day2.categoryIdentifier = "reminder"
        day2.sound = UNNotificationSound.default
        
        let day3 = UNMutableNotificationContent()
        day3.title = "Play again? Day3"
        day3.body = "Smash out a new highscore!"
        day3.categoryIdentifier = "reminder"
        day3.sound = UNNotificationSound.default
        
        let day4 = UNMutableNotificationContent()
        day4.title = "Play again? Day4"
        day4.body = "Smash out a new highscore!"
        day4.categoryIdentifier = "reminder"
        day4.sound = UNNotificationSound.default
        
        let day5 = UNMutableNotificationContent()
        day5.title = "Play again? Day5"
        day5.body = "Smash out a new highscore!"
        day5.categoryIdentifier = "reminder"
        day5.sound = UNNotificationSound.default
        
        let day6 = UNMutableNotificationContent()
        day6.title = "Play again? Day6"
        day6.body = "Smash out a new highscore!"
        day6.categoryIdentifier = "reminder"
        day6.sound = UNNotificationSound.default
        
        let day7 = UNMutableNotificationContent()
        day7.title = "Play again? Day7"
        day7.body = "Smash out a new highscore!"
        day7.categoryIdentifier = "reminder"
        day7.sound = UNNotificationSound.default
        
        let timeInterval: Double = 86400
        let triggerDay1 = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let requestDay1 = UNNotificationRequest(identifier: UUID().uuidString, content: day1, trigger: triggerDay1)
        
        let triggerDay2 = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval * 2, repeats: false)
        let requestDay2 = UNNotificationRequest(identifier: UUID().uuidString, content: day2, trigger: triggerDay2)
        
        let triggerDay3 = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval * 3, repeats: false)
        let requestDay3 = UNNotificationRequest(identifier: UUID().uuidString, content: day3, trigger: triggerDay3)
        
        let triggerDay4 = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval * 4, repeats: false)
        let requestDay4 = UNNotificationRequest(identifier: UUID().uuidString, content: day4, trigger: triggerDay4)
        
        let triggerDay5 = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval * 5, repeats: false)
        let requestDay5 = UNNotificationRequest(identifier: UUID().uuidString, content: day5, trigger: triggerDay5)
        
        let triggerDay6 = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval * 6, repeats: false)
        let requestDay6 = UNNotificationRequest(identifier: UUID().uuidString, content: day6, trigger: triggerDay6)
        
        let triggerDay7 = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval * 7, repeats: false)
        let requestDay7 = UNNotificationRequest(identifier: UUID().uuidString, content: day7, trigger: triggerDay7)
        center.add(requestDay1)
        center.add(requestDay2)
        center.add(requestDay3)
        center.add(requestDay4)
        center.add(requestDay5)
        center.add(requestDay6)
        center.add(requestDay7)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
        let category = UNNotificationCategory(identifier: "reminder", actions: [show], intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("Default identifier")
            center.removeAllPendingNotificationRequests()
        default:
            print("Test")
            break
        }
        completionHandler()
    }
}

