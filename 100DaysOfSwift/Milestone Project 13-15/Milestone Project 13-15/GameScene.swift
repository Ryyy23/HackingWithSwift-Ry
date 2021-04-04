//
//  GameScene.swift
//  Milestone Project 13-15
//
//  Created by Ryordan Panter on 3/4/21.
//

import SpriteKit


class GameScene: SKScene {
    
    var gameScore : SKLabelNode!
    var countdownLabel: SKLabelNode!
    var slots = [TargetSlot]()
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    
    var countdownTimer = 0 {
        didSet {
            countdownLabel.text = "Time: \(countdownTimer)"
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "251204.png")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "GillSans-Bold")
        gameScore.text = "Score: 0 "
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        gameScore.zPosition = 1
        addChild(gameScore)
        
        countdownLabel = SKLabelNode(fontNamed: "GillSans-Bold")
        countdownLabel.text = "Time: 0"
        countdownLabel.position = CGPoint(x: 220, y: 8)
        countdownLabel.horizontalAlignmentMode = .left
        countdownLabel.fontSize = 48
        countdownLabel.zPosition = 1
        addChild(countdownLabel)
        startGame()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            [weak self] in
            self?.moveTargets()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func createTargets(at position: CGPoint, row: Int){
//        iniate 3 slots
        let slot = TargetSlot()
        slot.configure(at: position, row: row)
        addChild(slot)
        slots.append(slot)
    }
    
    func startGame(){
        let randomNumber = Int.random(in: 1...3)
        
        switch randomNumber {
        case 1:
            createTargets(at: CGPoint(x: 0, y: 100), row: 1)
        case 2:
            createTargets(at: CGPoint(x: 500, y: 200), row: 2)
        case 3:
            createTargets(at: CGPoint(x: 0, y: 300), row: 3)
        default:
            return
        }
        print("created at: \(randomNumber)")
    }
    
    func moveTargets(){
        for node in slots {
            if node.row == 1 || node.row == 3 {
                node.self.run(SKAction.moveBy(x: 50, y: 0, duration: 1))
                print("row: \(node.row)")
            } else {
                node.self.run(SKAction.moveBy(x: -50, y: 0, duration: 1))
                print("row: \(node.row)")}
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.250) {
            [weak self] in
            self?.moveTargets()
        }
        
    }
}
