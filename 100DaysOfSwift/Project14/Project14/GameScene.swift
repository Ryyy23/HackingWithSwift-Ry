//
//  GameScene.swift
//  Project14
//
//  Created by Ryordan Panter on 27/3/21.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var goodPenguinSound: AVAudioPlayer?
    var badPenguinSound: AVAudioPlayer?
    var gameOverSound: AVAudioPlayer?
    
    var slots = [WhackSlot]()
    var popupTime = 0.85
    var numRound = 0
    
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
        
    override func didMove(to view: SKView) {
        loadSoundEffects()
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "GillSans-Bold")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))}
        for i in 0..<5 {createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))}
        for i in 0..<4 {createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            
            // SpriteNode -> CropNode -> WackSlot -> Screen
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisable { continue }
            if whackSlot.isHit { continue }
            smokeParticles(whackSlot: whackSlot)
            whackSlot.hit()
            
            if node.name == "charFriend" {
                
                score -= 5
                goodPenguinSound?.play()
//                goodPenguinSound?.stop()
                
//                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion:true))
                
            } else if node.name == "charEnemy" {
                
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                whackSlot.hit()
                score += 1
                badPenguinSound?.play()
//                badPenguinSound?.stop()
//                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:true))

            }
        }
    }
    
    func smokeParticles(whackSlot: SKNode){
        if let smokeParticles = SKEmitterNode(fileNamed: "smokeParticle") {
            smokeParticles.position = whackSlot.position
            smokeParticles.zPosition = 1
            addChild(smokeParticles)
            print("Working")
            
        }
    }
    func mudParticles(whackSlot: SKNode){
        if let mudParticles = SKEmitterNode(fileNamed: "mudParticle") {
            mudParticles.position = whackSlot.position
            mudParticles.zPosition = 1
            addChild(mudParticles)
            print("Working")
                
        }
    }
    
    func loadSoundEffects(){
        
        guard let goodPenguinSoundURL = Bundle.main.url(forResource: "whack", withExtension: "caf") else {
            print("Error Good penguin sound")
            return
        }
        guard let badPenguinSoundURL = Bundle.main.url(forResource: "whackBad", withExtension: "caf") else {
            print("Error Bad penguin sound")
            return
        }
        guard let gameOverSoundURL = Bundle.main.url(forResource: "gameOverSound", withExtension: "mp3") else {
            print("Error Game over sound")
            return
        }
        do {
            goodPenguinSound = try AVAudioPlayer(contentsOf: goodPenguinSoundURL)
            badPenguinSound = try AVAudioPlayer(contentsOf: badPenguinSoundURL)
            gameOverSound = try AVAudioPlayer(contentsOf: gameOverSoundURL)
        } catch {
            print("Error")
            return
        }

    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        
        numRound += 1
        
        if numRound >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            gameOverSound?.play()
//            gameOverSound?.stop()
//            run(SKAction.playSoundFileNamed("gameOverSound.mp3", waitForCompletion: true))
            
            let finalScoreLabel = SKLabelNode(fontNamed: "GillSans-Bold")
            finalScoreLabel.text = "Final Score: \(score)"
            finalScoreLabel.fontSize = 48
            finalScoreLabel.position = CGPoint(x: 512, y: 300)
            finalScoreLabel.zPosition = 1
            addChild(finalScoreLabel)
            
            return
        }
        
        popupTime *= 0.991
        
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...12) > 4 {slots[1].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 8 {slots[2].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 10 {slots[3].show(hideTime: popupTime)}
        if Int.random(in: 0...12) > 11 {slots[4].show(hideTime: popupTime)}
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
        
        
    }
}
