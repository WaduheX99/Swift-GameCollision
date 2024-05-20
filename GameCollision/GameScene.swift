//
//  GameScene.swift
//  GameCollision
//
//  Created by Faza Faresha Affandi on 14/05/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let anvilCategory:UInt32 = 0x1 // 0000 0001 (1)
    let fishCategory:UInt32 = 0x10 // 0000 0010 (2)
    let characterCategory:UInt32 = 0x100 // 0000 0100 (4)
    let groundCategory:UInt32 = 0x1000 // 0000 1000 (8)
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var character : SKSpriteNode?
    private var characterTextures :[SKTexture] = []
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//label") as? SKLabelNode
        self.character = self.childNode(withName: "//character") as? SKSpriteNode
        
        characterTextures.append(SKTexture(imageNamed: "idle1"))
        characterTextures.append(SKTexture(imageNamed: "idle2"))
        characterTextures.append(SKTexture(imageNamed: "idle3"))
        characterTextures.append(SKTexture(imageNamed: "idle4"))
        characterTextures.append(SKTexture(imageNamed: "idle5"))
        
        let animation = SKAction.animate(with: characterTextures, timePerFrame: 0.2)
        let animationRepeat = SKAction.repeatForever(animation)
        character!.run(animationRepeat)
        
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
    }
    
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
