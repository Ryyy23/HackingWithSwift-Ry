//
//  ViewController.swift
//  Milestone Project 7-9
//
//  Created by Ryordan Panter on 10/7/20.
//  Copyright © 2020 Ryordan Panter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // letterGuess
    // usedLetters
    // score/lives
    
    var scoreLabel: UILabel!
    var answerLabel: UILabel!
    
    var characterButtons = [UIButton]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
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
        answerLabel.text = "ANSWER"
        answerLabel.numberOfLines = 1
        answerLabel.textAlignment = .center
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        let row1View = UIView()
        row1View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(row1View)
        
        let row2View = UIView()
        row2View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(row2View)
        
        let row3View = UIView()
        row3View.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(row3View)

        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 25),
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 1000),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            row1View.topAnchor.constraint(equalTo: buttonsView.topAnchor),
//            row1View.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            row1View.widthAnchor.constraint(equalToConstant: 25),
//            row1View.heightAnchor.constraint(equalToConstant: 25),
            row1View.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 0.333),
           
            
            row2View.topAnchor.constraint(equalTo: row1View.bottomAnchor),
//            row2View.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
//            row2View.widthAnchor.constraint(equalToConstant: 25),
//            row2View.heightAnchor.constraint(equalToConstant: 25),
            row2View.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 0.333),
            
            row3View.topAnchor.constraint(equalTo: row2View.bottomAnchor),
//            row3View.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
//            row3View.widthAnchor.constraint(equalToConstant: 25),
//            row3View.heightAnchor.constraint(equalToConstant: 25),
            row3View.heightAnchor.constraint(equalTo: buttonsView.heightAnchor, multiplier: 0.333),
            
            
            
            
            
            
        ])
        
        let width = 25
        let height = 100
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
                
                characterButton.layer.borderWidth = 2
                characterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                characterButton.setTitle("#", for: .normal)
                
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                characterButton.frame = frame
                
                //TODO: make three buttonsViews. one for each row
                
                switch row {
                case 0:
                    print("row 1")
                    row1View.addSubview(characterButton)
                case 1:
                    print("row 2")
                   row2View.addSubview(characterButton)
                case 2:
                    print("row 3")
                    row3View.addSubview(characterButton)
                default:
                    return
                }
                
                characterButtons.append(characterButton)
                
                characterButton.addTarget(self, action: #selector(characterTapped), for: .touchUpInside)
            }
            i -= 1
        }
        
        answerLabel.backgroundColor = .brown
        buttonsView.backgroundColor = .purple
        row1View.backgroundColor = .red
        row2View.backgroundColor = .yellow
        row3View.backgroundColor = .green
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    @objc func characterTapped() {
        
    }
    
    func loadLevel() {
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

       //for value in UnicodeScalar("a").value...UnicodeScalar("z").value { print(UnicodeScalar(value)!) }
    }
    



}

