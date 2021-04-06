//
//  GameScene.swift
//  Milestone Project 13-15
//
//  Created by Ryordan Panter on 3/4/21.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    var countdownLabel: SKLabelNode!
    var bulletsLeftLabel: SKLabelNode!
    var reloadButton: UIButton!
    
    var slots = [TargetSlot]()
    
    let brownDuckTexture = SKTexture(imageNamed: "brownduck")
    let duckTexture = SKTexture(imageNamed: "duck")
    let frogTexture = SKTexture(imageNamed: "frog")
    let crocodileTexture = SKTexture(imageNamed: "crocodile")
    let posionAppleTexture = SKTexture(imageNamed: "posionapple")
    let targetTexture = SKTexture(imageNamed: "target")
    
    let rowDistribution = GKShuffledDistribution(lowestValue: 1, highestValue: 3)
    let textureDistribution = GKShuffledDistribution(lowestValue: 1, highestValue: 6)
    let moveSpeedDistribution = GKRandomDistribution(lowestValue: 20, highestValue: 50)
    
    var gameInProgress = true
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var bulletsLeft = 6 {
        didSet {
            bulletsLeftLabel.text = "Bullets: \(bulletsLeft)"
        }
    }
    
    var timer:Timer?
    var timeLeft = 60 {
        didSet {
            countdownLabel.text = "Time: \(timeLeft)"
            if timeLeft <= 0 {
                gameOver()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "251204.png")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "GillSans-Bold")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        gameScore.zPosition = 1
        addChild(gameScore)
        
        countdownLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        countdownLabel.text = "Time: 0"
        countdownLabel.position = CGPoint(x: 250, y: 8)
        countdownLabel.horizontalAlignmentMode = .left
        countdownLabel.fontSize = 48
        countdownLabel.zPosition = 1
        addChild(countdownLabel)
        
        bulletsLeftLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        bulletsLeftLabel.text = "Bullets: 6"
        bulletsLeftLabel.position = CGPoint(x: 475, y: 8)
        bulletsLeftLabel.horizontalAlignmentMode = .left
        bulletsLeftLabel.fontSize = 48
        bulletsLeftLabel.zPosition = 1
        addChild(bulletsLeftLabel)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.moveTargets()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if bulletsLeft <= 0 {
            return
        }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
//         all touches count as a shoot
        bulletsLeft -= 1
        
        for node in tappedNodes {
            guard let targetSlot = node.parent as? TargetSlot else { return }
            
            if node.name == "good" {
                score += 1
            } else if node.name == "bad" {
                score -= 1
            }
            
            targetSlot.removeEnemy()
            targetSlot.removeFromParent()
            //            print(slots.count)
            let itemToRemove = targetSlot
            if let index = slots.firstIndex(of: itemToRemove){
                slots.remove(at: index)
            }
            //            print(slots.count)
            
        }
    }
    
    func createTarget(at position: CGPoint, row: Int, texture: SKTexture, trait: String, scale: CGFloat, moveSpeed: Int){
        let slot = TargetSlot()
        //        print(position, row, texture, trait, scale)
        slot.configure(at: position, row: row, texture: texture, trait: trait, scale: scale, moveSpeed: moveSpeed)
        addChild(slot)
        slots.append(slot)
    }
    
    //    var previousNumber = 0
    func createEnemy(){
        var texture: SKTexture
        var trait: String
        var scale: CGFloat
        var moveSpeed: Int
        //        let randomNum = Int.random(in: 1...6)
        let randomNum = textureDistribution.nextInt()
        switch randomNum {
        case 1:
            texture = brownDuckTexture
            trait = "good"
            scale = 0.2
        case 2:
            texture = duckTexture
            trait = "good"
            scale = 0.2
        case 3:
            texture = frogTexture
            trait = "good"
            scale = 0.4
        case 4:
            texture = crocodileTexture
            trait = "bad"
            scale = 0.3
        case 5:
            texture = posionAppleTexture
            trait = "bad"
            scale = 0.2
        case 6:
            texture = targetTexture
            trait = "bad"
            scale = 0.2
        default:
            return
        }
        
        //        let randomNumber = Int.random(in: 1...3)
        //        if previousNumber == 0 {
        //            previousNumber = randomNumber
        //        } else if previousNumber == randomNumber {
        //
        //        }
        let randomNumber = rowDistribution.nextInt()
        moveSpeed = moveSpeedDistribution.nextInt()
        switch randomNumber {
        case 1:
            createTarget(at: CGPoint(x: -50, y: 100), row: 1, texture: texture, trait: trait, scale: scale, moveSpeed: moveSpeed)
        case 2:
            createTarget(at: CGPoint(x: 550, y: 200), row: 2, texture: texture, trait: trait, scale: scale, moveSpeed: moveSpeed)
        case 3:
            createTarget(at: CGPoint(x: -50, y: 300), row: 3, texture: texture, trait: trait, scale: scale, moveSpeed: moveSpeed)
        default:
            return
        }
        //        print("created at: \(randomNumber)")
        
        if gameInProgress == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                [weak self] in
                self?.createEnemy()
            }
        }
    }
    
    func moveTargets(){
        for (index, element) in slots.enumerated() {
            if element.position .x >= 1150 || element.position .x <= -650 {
//                //                print(slots.count)
                element.removeEnemy()
                element.removeFromParent()
                slots.remove(at: index)
//                //                print(slots.count)
            } else {
                let moveSpeed: Int = element.moveSpeed
                let moveSpeedNegative: Int = -moveSpeed
                if element.row == 1 || element.row == 3 {
                    let moveSpeedFloat = CGFloat(moveSpeed)
                    element.run(SKAction.moveBy(x: moveSpeedFloat, y: 0, duration: 0.5))
                } else {
                    let moveSpeedFloat = CGFloat(moveSpeedNegative)
                    element.run(SKAction.moveBy(x:moveSpeedFloat , y: 0, duration: 0.5))
                }
            }
        }
        
        
        
        //        for i in 0 ..< slots.count {
        ////            print("count: \(i)")
        //
        //            if slots[i].row == 1 || slots[i].row == 3 {
        //                slots[i].self.run(SKAction.moveBy(x: 20, y: 0, duration: 0.5))
        ////                print("row: \(slots[i].row)")
        //            } else {
        //                slots[i].self.run(SKAction.moveBy(x: -20, y: 0, duration: 0.5))
        ////                print("row: \(slots[i].row)")
        //
        //            }
        //
        //            if slots[i].position .x >= 1100 || slots[i].position .x <= -600  {
        ////                print(slots.count)
        //                slots[i].removeEnemy()
        //                slots[i].removeFromParent()
        //                print(i)
        //                print(slots.count)
        //                print(slots[i])
        //                slots.remove(at: i)
        //                print(slots.count)
        //            }
        //        }
        if gameInProgress == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                [weak self] in
                self?.moveTargets()
            }
        }
    }
    
    @objc func onTimerFires() {
        timeLeft -= 1
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func gameOver() {
        gameInProgress = false
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)
        
        let finalScoreLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        finalScoreLabel.position = CGPoint(x: 512, y: 300)
        finalScoreLabel.text = "Final Score: \(score)"
        finalScoreLabel.fontSize = 48
        finalScoreLabel.zPosition = 1
        addChild(finalScoreLabel)
        
    }
    
    @objc func reloadBullets() {
        
        
        
        bulletsLeft = 6
        
    }
}
