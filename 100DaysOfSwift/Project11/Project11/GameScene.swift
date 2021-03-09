//
//  GameScene.swift
//  Project11
//
//  Created by Ryordan Panter on 6/3/21.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var ballsLeftLabel: SKLabelNode!
    
    let maxAmountofLives = 5
    var ballsLeft = 5 {
        didSet {
            if ballsLeft == 0 {
                print("Game Over")
            }
            
            ballsLeftLabel.text = "Balls: \(ballsLeft)"
        }
    }
    
    var editLabel: SKLabelNode!
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
        ballsLeftLabel = SKLabelNode(fontNamed: "Chalkduster")
        ballsLeftLabel.text = "Balls: 5"
        ballsLeftLabel.position = CGPoint(x: 700, y: 700)
        addChild(ballsLeftLabel)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
               
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }
    var box: SKSpriteNode!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let objects = nodes(at: location)
        
        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                // create a box
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location
                box.name = "box"
                
                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
//                guard let someNodeExists = self.childNode(withName: "box") else {return}
//                print(someNodeExists)
            } else {
                let ball = SKSpriteNode(imageNamed: ballColour())
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                // if Y value within range of uppper screen??
                if location.y >= 600 {
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                } else { return }
            }
        }
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func ballColour () -> String {
        var ballColour = ""
        let randomNumber = Int.random(in: 1...7)
        switch randomNumber {
        case 1:
            ballColour = "ballBlue"
        case 2:
            ballColour = "ballCyan"
        case 3:
            ballColour = "ballGreen"
        case 4:
            ballColour = "ballGrey"
        case 5:
            ballColour = "ballPurple"
        case 6:
            ballColour = "ballRed"
        case 7:
            ballColour = "ballYellow"
        default:
            ballColour = "ballRed"
        }
        return ballColour
        
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotGlow)
        addChild(slotBase)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collision(between ball: SKNode, object: SKNode){
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
            if ballsLeft < maxAmountofLives {
                ballsLeft += 1
            }
        } else if object.name == "bad"  {
            destroy(ball: ball)
            score -= 1
            ballsLeft -= 1
        }
    }
    
    func boxDestroy(box: SKNode) {
        checkNodeExists()
        box.removeFromParent()
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collision(between: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collision(between: nodeB, object: nodeA)
        }
        
        if nodeA.name == "box" {
//            guard let someNodeExists = self.childNode(withName: "box") else {return}
//            print(someNodeExists)
            boxDestroy(box: nodeA)
            checkNodeExists()
        } else if nodeB.name == "box" {
//            guard let someNodeExists = self.childNode(withName: "box") else {return}
//            print(someNodeExists)
            boxDestroy(box: nodeB)
            checkNodeExists()
        }
    }
    
    func checkNodeExists() {
        var boxChildrenNodesArray = [SKNode]()
        let _: Void = self.enumerateChildNodes(withName: "box", using: {
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            boxChildrenNodesArray.append(node)
//            print(node!)
        })
        if boxChildrenNodesArray.isEmpty && ballsLeft > 0 {
            // game won
            print("win")
        } else if ballsLeft == 0 {
            // game still in play if balls left or game over/lose
            print("loss")
        } else {
            print("still in game")
        }

        }
    // func game over
    //func won
    // func menu
          
//        guard let someNodeExists = self.childNode(withName: "box") else {return}
//        for node in someNodeExists {
//            print(node)
//        }
        
    
    
}
