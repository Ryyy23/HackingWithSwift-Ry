//
//  TargetSlot.swift
//  Milestone Project 13-15
//
//  Created by Ryordan Panter on 3/4/21.
//

import UIKit
import SpriteKit

class TargetSlot: SKNode {
    var targetNode: SKSpriteNode!
    
    var row = 0
    
    var isVisable = false
    var isHit = false

    
    func configure(at position: CGPoint, row: Int) {
        self.position = position
        self.row = row
        
        let randomNum = Int.random(in: 1...6)
        switch randomNum {
        case 1:
            targetNode = SKSpriteNode(imageNamed: "brownduck")
            targetNode.name = "good"
            targetNode.setScale(0.2)
        case 2:
            targetNode = SKSpriteNode(imageNamed: "duck")
            targetNode.name = "good"
            targetNode.setScale(0.2)
        case 3:
            targetNode = SKSpriteNode(imageNamed: "frog")
            targetNode.name = "good"
            targetNode.setScale(0.4)
        case 4:
            targetNode = SKSpriteNode(imageNamed: "crocodile")
            targetNode.name = "bad"
            targetNode.setScale(0.3)
        case 5:
            targetNode = SKSpriteNode(imageNamed: "posionapple")
            targetNode.name = "bad"
            targetNode.setScale(0.2)
        case 6:
            targetNode = SKSpriteNode(imageNamed: "target")
            targetNode.name = "bad"
            targetNode.setScale(0.2)
        default:
            return
        }
        
        targetNode.position = position
        addChild(targetNode)
        
        
        
    }
}
