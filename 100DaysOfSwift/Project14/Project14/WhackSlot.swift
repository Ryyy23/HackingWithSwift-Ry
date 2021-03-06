//
//  WhackSlot.swift
//  Project14
//
//  Created by Ryordan Panter on 29/3/21.
//

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    var charNode: SKSpriteNode!
    
    var isVisable = false
    var isHit = false
    
    func configure(at position: CGPoint){
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        cropNode.zPosition = 1
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
        
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        cropNode.addChild(charNode)
        
        addChild(cropNode)
        
    }
    
    func show(hideTime: Double) {
        // exit if penguin is visable
        if isVisable { return }
        
        // put penguin back to normal scale
        charNode.xScale = 1
        charNode.yScale = 1
        
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisable = true
        isHit = false
        
        if let mudParticles = SKEmitterNode(fileNamed: "mudParticle") {
            mudParticles.position = charNode.position
            mudParticles.run(SKAction.moveBy(x: 0, y: 65, duration: 0))
            mudParticles.zPosition = 1
            addChild(mudParticles)
        }
        
        if Int.random(in: 0...2) == 0 {
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) {
            [weak self] in
            self?.hide()

        }
    }
    
    
    func hide() {
        if !isVisable { return }

        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisable = false

    }
    
    func hit() {
        isHit = true
        
        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisable = SKAction.run {
            [weak self] in
            self?.isVisable = false
        }
        charNode.run(SKAction.sequence([delay,hide,notVisable]))
    }

}
