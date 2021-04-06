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
    
    var row: Int!
    var texture: SKTexture!
    var trait: String!
    var scale: CGFloat!
    var moveSpeed: Int!
    

//    func configure(at position: CGPoint, row: Int, texture: SKTexture, triat: String, scale: CGFloat) {
    func configure(at position: CGPoint, row: Int, texture: SKTexture, trait: String, scale: CGFloat, moveSpeed: Int){
        self.position = position
        self.row = row
        self.texture = texture
        self.trait = trait
        self.scale = scale
        self.moveSpeed =  moveSpeed
//        print(position, row, texture, triat, scale)
        targetNode = SKSpriteNode(texture: texture)
        targetNode.name = trait
        targetNode.setScale(scale)
        
        targetNode.position = position
        addChild(targetNode)
    }
    
    func removeEnemy() {
        targetNode.removeFromParent()
        targetNode.removeAllActions()
    }
}
