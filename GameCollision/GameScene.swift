//
//  GameScene.swift
//  GameCollision
//
//  Created by Faza Faresha Affandi on 14/05/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let rockCategory:UInt32 = 0x1 // 0000 0001 (1)
    let fishCategory:UInt32 = 0x10 // 0000 0010 (2)
    let characterCategory:UInt32 = 0x100 // 0000 0100 (4)
    let groundCategory:UInt32 = 0x1000 // 0000 1000 (8)
    
    var isTouching = false
    var touchDirection: CGFloat = 0.0
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var character : SKSpriteNode!
    private var idleTextures :[SKTexture] = []
    private var moveRightTextures: SKAction!
    private var moveLeftTextures: SKAction!
    private var idleAnimation: SKAction!
    
    private var numObjs = 0
    private var collectedFish = 0
    
    override func didMove(to view: SKView) {
        
        self.scaleMode = .aspectFit
        
        self.physicsWorld.contactDelegate = self
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//label") as? SKLabelNode
        self.character = (self.childNode(withName: "//character") as? SKSpriteNode)!
        
        
//        character.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        
        
        // idle animation
        idleTextures.append(SKTexture(imageNamed: "idle1"))
        idleTextures.append(SKTexture(imageNamed: "idle2"))
        idleTextures.append(SKTexture(imageNamed: "idle3"))
        idleTextures.append(SKTexture(imageNamed: "idle4"))
        idleTextures.append(SKTexture(imageNamed: "idle5"))
        
        idleAnimation = SKAction.repeatForever(SKAction.animate(with: idleTextures, timePerFrame: 0.2))
        character.run(idleAnimation, withKey: "idleAnimation")
//        let animationRepeat = SKAction.repeatForever(animation)
//        character.run(animationRepeat)
        
        
        
        // move Right animation
        let moveRightFrames = [
            SKTexture(imageNamed: "moveRight1"),
            SKTexture(imageNamed: "moveRight2"),
            SKTexture(imageNamed: "moveRight3"),
            SKTexture(imageNamed: "moveRight4"),
            SKTexture(imageNamed: "moveRight5"),
            SKTexture(imageNamed: "moveRight6"),
            SKTexture(imageNamed: "moveRight7"),
        ]
        moveRightTextures = SKAction.animate(with: moveRightFrames, timePerFrame: 0.2)
        
        // move Left animation
        let moveLeftFrames = [
            SKTexture(imageNamed: "moveLeft1"),
            SKTexture(imageNamed: "moveLeft2"),
            SKTexture(imageNamed: "moveLeft3"),
            SKTexture(imageNamed: "moveLeft4"),
            SKTexture(imageNamed: "moveLeft5"),
            SKTexture(imageNamed: "moveLeft6"),
            SKTexture(imageNamed: "moveLeft7")
        ]
        moveLeftTextures = SKAction.animate(with: moveLeftFrames, timePerFrame: 0.2)
        
        // Memastikan scene update secara berkala
        let actionWait = SKAction.wait(forDuration: 0.01)
        let actionRun = SKAction.run { [weak self] in
            self?.updateCharacterPosition()
        }
        let sequence = SKAction.sequence([actionWait, actionRun])
        let repeatForever = SKAction.repeatForever(sequence)
        self.run(repeatForever)
        
        // Physics
        character.physicsBody?.categoryBitMask = characterCategory
        character.physicsBody?.contactTestBitMask = fishCategory | rockCategory
        character.physicsBody?.collisionBitMask = fishCategory | rockCategory
        
        let ground = self.childNode(withName: "//ground") as?SKSpriteNode
        ground?.physicsBody?.categoryBitMask = groundCategory
        ground?.physicsBody?.contactTestBitMask = fishCategory | rockCategory
        ground?.physicsBody?.collisionBitMask = fishCategory | rockCategory
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.8)
    }
    
    func dropObj() {
        // randomly select what to drop and where to position it
        let random = Int.random(in: 1...2) // 1 = rock  2 = fish
        let randomX = Int.random(in: -560...560)
        let randomY = Int.random(in: 1200...1280)
        
        var obj = SKSpriteNode(imageNamed: "fish")
        obj.position = CGPoint(x: randomX, y: randomY)
        obj.size = CGSize(width: 200, height: 200)
        obj.name = "fish"
        
        obj.physicsBody = SKPhysicsBody.init(circleOfRadius: 40)
        obj.physicsBody?.categoryBitMask = fishCategory
        obj.physicsBody?.contactTestBitMask = groundCategory | characterCategory
        addChild(obj)
        
        if (random == 1) {
            obj.name = "rock"
            obj.texture = SKTexture(imageNamed: "rock")
            obj.physicsBody?.categoryBitMask = rockCategory
        }
        
        numObjs += 1
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        let touch = touches.first
//        if let location = touch?.location(in: self) {
//            if location.x > (character.position.x)! {
//                character.position.x += 50 // move character to right
//            }
//            else if location.x < (character.position.x)! {
//                character.position.x -= 50 // move character to left
//            }
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        isTouching = true
        touchDirection = location.x < frame.midX ? -1.0 : 1.0
        
        // Menghentikan animasi idle ketika sedang berjalan
        character.removeAction(forKey: "idleAnimation")
        
        // Menjalankan animasi berjalan sesuai arah
        if touchDirection > 0 {
            if character.action(forKey: "moveLeftTextures") != nil {
                character.removeAction(forKey: "moveLeftTextures")
            }
            if character.action(forKey: "moveRightTextures") == nil {
                character.run(SKAction.repeatForever(moveRightTextures), withKey: "moveRightTextures")
            }
        } else {
            if character.action(forKey: "moveRightTextures") != nil {
                character.removeAction(forKey: "moveRightTextures")
            }
            if character.action(forKey: "moveLeftTextures") == nil {
                character.run(SKAction.repeatForever(moveLeftTextures), withKey: "moveLeftTextures")
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        touchDirection = 0.0
        
        // Menghentikan animasi berjalan
        character.removeAction(forKey: "moveRightTextures")
        character.removeAction(forKey: "moveLeftTextures")
        
        // idle animation
        character.run(idleAnimation, withKey: "idleAnimation")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = false
        touchDirection = 0.0
        
        // Menghentikan animasi berjalan
        character.removeAction(forKey: "moveRightTextures")
        character.removeAction(forKey: "moveLeftTextures")
        
        // idle animation
        character.run(idleAnimation, withKey: "idleAnimation")
    }
    
    func updateCharacterPosition() {
        if isTouching {
            let moveSpeed: CGFloat = 3.5
            character.position.x += touchDirection * moveSpeed
            
            // Menentukan batas frame
            let leftBoundary = frame.minX + character.size.width / 2
            let rightBoundary = frame.maxX - character.size.width / 2
            
            // Membatasi posisi karakter
            if character.position.x < leftBoundary {
                character.position.x = leftBoundary
            }
            else if character.position.x > rightBoundary {
                character.position.x = rightBoundary
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        print("**Contact \(bodyA) and \(bodyB)")
        
        
        // Menghilangkan objek yang telah menyentuh daratan
        if((bodyA == "ground") && (bodyB == "rock")) || ((bodyA == "ground") && (bodyB == "fish")) {
            contact.bodyB.node?.removeFromParent()
            numObjs -= 1
        }
        else if((bodyA == "fish") && (bodyB == "ground")) || ((bodyA == "rock") && (bodyB == "ground")) {
            contact.bodyA.node?.removeFromParent()
            numObjs -= 1
        }
        
        
        // Menghitung banyak ikan
        let collision: UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == characterCategory | fishCategory {
            collectedFish += 1
            label?.text = "\(collectedFish)"
            if (bodyA == "fish"){
                contact.bodyA.node?.removeFromParent()
                numObjs -= 1
            }
            else {
                contact.bodyB.node?.removeFromParent()
                numObjs -= 1
            }
            
            
            // Kondisi jika menang
            if collectedFish >= 10 {
                let scene = GameOver(fileNamed: "GameOver")
                scene!.win = true
                scene!.scaleMode = .aspectFit
                let transition = SKTransition.push(with: .up, duration: 3.0)
                self.view?.presentScene(scene!, transition: transition)
            }
        }
        // Jika terkena batu dan kalah
        else if collision == characterCategory | rockCategory {
            character.texture = SKTexture(imageNamed: "hit")
            let scene = GameOver(fileNamed: "GameOver")
            scene!.win = false
            scene!.scaleMode = .aspectFit
            let transition = SKTransition.push(with: .up, duration: 3.0)
            self.view?.presentScene(scene!, transition: transition)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (numObjs < 7) {
            dropObj()
        }
        
        // Called before each frame is rendered
    }
}
