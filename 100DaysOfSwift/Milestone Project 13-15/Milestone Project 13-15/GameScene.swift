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
    let moveSpeedDistribution = GKRandomDistribution(lowestValue: 150, highestValue: 250)
    
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
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            [weak self] in
//            self?.moveTargets()
//        }
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
    
    func createTarget(at position: CGPoint, row: Int, texture: SKTexture, trait: String, scale: CGFloat, endpoint: CGPoint){
        let slot = TargetSlot()
        //        print(position, row, texture, trait, scale)
        slot.configure(at: position, row: row, texture: texture, trait: trait, scale: scale)
        addChild(slot)
        slots.append(slot)
        let speed = CGFloat(moveSpeedDistribution.nextInt())
        let moveObject = SKAction.move(to: endpoint, duration: getDuration(pointA: slot.position, pointB:endpoint, speed:speed))
        if gameInProgress == false {
            slot.removeAllActions()
        } else {
            slot.run(moveObject){  [ weak self] in
                self?.removeTarget()
            }
        }
    }
    
    func createEnemy(){
        var texture: SKTexture
        var trait: String
        var scale: CGFloat
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
        
        let randomNumber = rowDistribution.nextInt()
        switch randomNumber {
        case 1:
            let endpoint = CGPoint(x: 1150, y: 100)
            createTarget(at: CGPoint(x: -50, y: 100), row: 1, texture: texture, trait: trait, scale: scale, endpoint: endpoint)
        case 2:
            let endpoint = CGPoint(x: -650, y: 200)
            createTarget(at: CGPoint(x: 550, y: 200), row: 2, texture: texture, trait: trait, scale: scale, endpoint: endpoint)
        case 3:
            let endpoint = CGPoint(x: 1150, y: 300)
            createTarget(at: CGPoint(x: -50, y: 300), row: 3, texture: texture, trait: trait, scale: scale, endpoint: endpoint)
        default:
            return
        }
        //        print("created at: \(randomNumber)")
        
        if gameInProgress == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                [weak self] in
                self?.createEnemy()
            }
        }
    }
    
    func getDuration(pointA: CGPoint, pointB: CGPoint, speed: CGFloat) -> TimeInterval{
        let xDist = (pointB.x - pointA.x)
        let yDist = (pointB.y - pointA.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist));
        let duration: TimeInterval = TimeInterval(distance/speed)
        return duration
        
    }
    
    func removeTarget(){
        for (index, element) in slots.enumerated() {
            if element.position .x >= 1150 || element.position .x <= -650 {
                element.removeEnemy()
                element.removeFromParent()
                slots.remove(at: index)
            }
        }
    }
        
//    func moveTargets(){
//        for (index, element) in slots.enumerated() {
//            if element.position .x >= 1150 || element.position .x <= -650 {
//                element.removeEnemy()
//                element.removeFromParent()
//                slots.remove(at: index)
//            } else {
//                let moveSpeed: Int = element.moveSpeed
//                let moveSpeedNegative: Int = -moveSpeed
//                let moveSpeedFloat = CGFloat(moveSpeed)
//                let moveSpeedFloatNegative = CGFloat(moveSpeedNegative)
//
//                if element.row == 1 || element.row == 3 {
////                    element.run(SKAction.speed(by: 1, duration: 20))
//                    element.run(SKAction.moveBy(x: 1500, y: 0, duration: 20.0))
//                } else {
////                    element.run(SKAction.speed(by: 1, duration: 20))
//                    element.run(SKAction.moveBy(x: -1500, y: 0, duration: 20.0))
//                }
//            }
//        }
//
//        if gameInProgress == true {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                [weak self] in
//                self?.moveTargets()
//            }
//        }
//    }
    
    @objc func onTimerFires() {
        timeLeft -= 1
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func gameOver() {
        gameInProgress = false
        
        for (index, element) in slots.enumerated() {
            element.removeAllActions()
        }
        
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
