//
//  GameScene.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 24.09.2023.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum Arrow {
        case left
        case right
    }
    
    enum ArrowState {
        case reduce
        case increase
    }
    
    var fruitCat: SKSpriteNode!
    var fruit: SKSpriteNode!
    var heart: SKSpriteNode!
    var arrowLeft: SKSpriteNode!
    var arrowRight: SKSpriteNode!
    var multiScoreLabel: SKLabelNode!
    var nextLevelLabel: SKLabelNode!
    
    var leftButtonIsPressed = false
    var rightButtonIsPressed = false
    var gameSounds = false
    
    var fruits: [String] = []
    var rareFruits: [String] = []
    var playerSkin: SkinType = .banana
    var currentScore = 0
    var health = 3
    var currentLevel = 1
    
    var createdFruits = 0
    var highScore = 0
    var skinHighScore: [SkinType: Int] = [:]
    var minTimeToMoveFruit: CGFloat = 0
    var maxTimeToMoveFruit: CGFloat = 0
    var timeForRegenerateFruit: CGFloat = 0
    
    var fruitsStorage: FruitsStorageProtocol = FruitsStorage()
    var fruitSkins: [SkinProtocol] = []
    var rareFruitsData: [RareFruitProtocol] = []
    
    weak var sceneDelegate: GameSceneProtocol?
    weak var gameAudioPlayer: GameAudioProtocol?
    
    override func didMove(to view: SKView) {
        scene?.size = getScreenSize()
        configureGame()
    }
    
    func configureGame() {
        setupBackground()
        
        loadSkinsData()
        loadFruitsData()
        loadSoundData()
        
        minTimeToMoveFruit = Constants.minTimeToMoveFruit
        maxTimeToMoveFruit = Constants.maxTimeToMoveFruit
        timeForRegenerateFruit = Constants.timeForRegenerateFruit
        
        fruits = FruitsType.allCases.map({ $0.rawValue })
        rareFruits = RareFruitsType.allCases.map({ $0.rawValue })
        
        configureWorld()
        configurePlayer()
        configureLeftArrow()
        configureRightArrow()
        configureMultiScoreLabel()
        configureNextLevelMessage()
        generateFruits()
    }
    
    func setupBackground() {
        let background = SKSpriteNode(imageNamed: Constants.mainBackgroundImage)
        background.size = size
        background.zPosition = -1
        addChild(background)
    }
    
    func loadSkinsData() {
        fruitSkins = fruitsStorage.loadPlayerSkin()
        
        for skin in fruitSkins {
            if skin.isSelected {
                playerSkin = skin.type
                skinHighScore[skin.type] = skin.record
                break
            }
        }
    }
    
    func loadFruitsData() {
        highScore = fruitsStorage.loadHighScore()
        rareFruitsData = fruitsStorage.loadFruitsData()
    }
    
    func loadSoundData() {
        gameSounds = fruitsStorage.loadSoundData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            if arrowLeft.contains(touchLocation) {
                leftButtonIsPressed = true
                animateArrow(arrow: .left, state: .reduce)
            }
            
            if arrowRight.contains(touchLocation) {
                rightButtonIsPressed = true
                animateArrow(arrow: .right, state: .reduce)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            leftButtonIsPressed = false
            rightButtonIsPressed = false
            
            animateArrow(arrow: .left, state: .increase)
            animateArrow(arrow: .right, state: .increase)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & PhysicsCategory.fruit != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.player != 0) {
            if let fruit = firstBody.node as? FruitNode,
               let player = secondBody.node as? FruitCatNode {
                fruitDidCollideWithPlayer(fruit, player)
            }
        }
        
        if (firstBody.categoryBitMask & PhysicsCategory.heart != 0) && (secondBody.categoryBitMask & PhysicsCategory.player != 0) {
            if let heart = firstBody.node as? HeartNode,
               let player = secondBody.node as? FruitCatNode {
                heartDidCollideWithPlayer(heart, player)
            }
        }
    }
    
    func fruitDidCollideWithPlayer(_ fruit: FruitNode, _ player: FruitCatNode) {
        playCollectedSound()
        
        updateScore(fruit.name ?? "")
        fruit.removeFromParent()
        
    }
    
    func heartDidCollideWithPlayer(_ heart: HeartNode, _ player: FruitCatNode) {
        playCollectedSound()
        
        health += 1
        
        if let heart = HeartList(rawValue: health) {
            self.sceneDelegate?.updateHearts(heart: heart, isSubtract: false)
        }
        heart.removeFromParent()
    }
    
    func updateScore(_ fruitName: String) {
        guard let currentRareFruit = RareFruitsType(rawValue: fruitName) else {
            currentScore += 1
            sceneDelegate?.updateScore(score: currentScore)
            return
        }
        
        currentScore += Constants.multiScoreValue
        sceneDelegate?.updateScore(score: currentScore)
        showMultiScoreLabel()
        
        if let rareIndex = rareFruitsData.firstIndex(where: { $0.type == currentRareFruit }) {
            rareFruitsData[rareIndex].collected += 1
        }
    }
    
    func showMultiScoreLabel() {
        multiScoreLabel.isHidden = false
        
        let actionFade = SKAction.fadeAlpha(to: 0, duration: 1.1)
        multiScoreLabel.run(actionFade) {
            self.multiScoreLabel.isHidden = true
            self.multiScoreLabel.alpha = 1.0
        }
    }
    
    func configureWorld() {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    
    func generateFruits() {
        let actionCreateNewFruit = SKAction.run(createFruit)
        let actionWait = SKAction.wait(forDuration: timeForRegenerateFruit)
        let actionRepeat = SKAction.run(generateFruits)
        let sequence = SKAction.sequence([actionCreateNewFruit, actionWait, actionRepeat])
        run(sequence)
    }
    
    func generateHealth() {
        let actionCreate = SKAction.run(self.createHealth)
        let waitDuration = CGFloat.random(in: 4.0...16.0)
        let actionWait = SKAction.wait(forDuration: waitDuration)
        let sequence = SKAction.sequence([actionWait, actionCreate])
        run(sequence)
    }
    
    func configurePlayer() {
        let player = FruitCat(sprite: playerSkin.rawValue, xScale: Constants.playerScale, yScale: Constants.playerScale)
        fruitCat = FruitCatNode(player)
        
        let xPos = frame.midX
        let yPos = -size.height / 2 + fruitCat.size.height
        fruitCat.position = CGPoint(x: xPos, y: yPos)
        fruitCat.zPosition = 2
        addChild(fruitCat)
    }
    
    func configureLeftArrow() {
        let scale = Constants.arrowScale
        let buttonArrow = ButtonArrow(sprite: Constants.leftButtonArrow, xScale: scale, yScale: scale)
        arrowLeft = ButtonArrowNode(buttonArrow)
        
        let xPos = frame.midX - size.width / 2 + arrowLeft.frame.width - 10
        let yPos = frame.midY - size.height / 2 + arrowLeft.frame.height + fruitCat.frame.height * 1.4
        arrowLeft.position = CGPoint(x: xPos, y: yPos)
        arrowLeft.zPosition = 2
        addChild(arrowLeft)
    }
    
    func configureRightArrow() {
        let scale = Constants.arrowScale
        let buttonArrow = ButtonArrow(sprite: Constants.rightButtonArrow, xScale: scale, yScale: scale)
        arrowRight = ButtonArrowNode(buttonArrow)
        
        let xPos = frame.midX + size.width / 2 - arrowRight.frame.width + 10
        let yPos = frame.midY - size.height / 2 + arrowRight.frame.height + fruitCat.frame.height * 1.4
        arrowRight.position = CGPoint(x: xPos, y: yPos)
        arrowRight.zPosition = 2
        addChild(arrowRight)
    }
    
    func configureMultiScoreLabel() {
        let text = GameText.getAttributedText(for: "+\(Constants.multiScoreValue)", size: 40.0, strokeWidth: -6.0, strokeColor: .orange)
        let position = CGPoint(x: frame.midX, y: frame.midY - 20)
        
        multiScoreLabel = SKLabelNode(attributedText: text)
        multiScoreLabel.position = position
        multiScoreLabel.isHidden = true
        multiScoreLabel.zPosition = 2
        addChild(multiScoreLabel)
    }
    
    func createFruit() {
        let randomFruit: String
        let chance = Int.random(in: 1...100)
        var rareFruit = false
        createdFruits += 1
        
        if chance <= Constants.rareFruitChance {
            guard let fruit = rareFruits.randomElement() else { return }
            randomFruit = fruit
            rareFruit = true
        } else {
            guard let fruit = fruits.randomElement() else { return }
            randomFruit = fruit
        }
        
        let scale = Constants.fruitScale
        let currentFruit = Fruit(type: randomFruit, xScale: scale, yScale: scale)
        fruit = FruitNode(currentFruit, physic: true)
        fruit.name = randomFruit
        
        let min = -size.width / 2 + fruitCat.size.width / 2
        let max = size.width / 2 - fruitCat.size.width / 2
        let randomPos = GKRandomDistribution(lowestValue: Int(min), highestValue: Int(max))
        let xPos = CGFloat(randomPos.nextInt())
        let yPos = size.height / 2 + fruit.size.height / 2
        
        fruit.position = CGPoint(x: xPos, y: yPos)
        fruit.zPosition = 1
        addChild(fruit)
        
        let loseAction = SKAction.run() {
            if let heart = HeartList(rawValue: self.health) {
                self.sceneDelegate?.updateHearts(heart: heart, isSubtract: true)
            }
            self.health -= 1
            self.generateHealth()
            
            if self.health <= 0 {
                self.playGameOverSound()
                self.saveScores()
                self.removeAllActions()
                self.removeAllChildren()
                self.sceneDelegate?.loadGameOverScene(score: self.currentScore)
            }
        }
        
        if rareFruit {
            animateRareItem(item: fruit, originScale: scale)
        }
        
        let timeDuration = getMoveTimeFruit(isRareFruit: rareFruit)
        let actionMove = SKAction.move(to: CGPoint(x: fruit.position.x, y: -size.height / 2), duration: timeDuration)
        let actionMoveDone = SKAction.removeFromParent()
        let sequence = SKAction.sequence([actionMove, loseAction, actionMoveDone])
        fruit.run(sequence)
    }
    
    func getMoveTimeFruit(isRareFruit: Bool) -> CGFloat {
        let timeDuration: CGFloat
        
        if createdFruits % 17 == 0 {
            if currentLevel < 12 {
                currentLevel += 1
                sceneDelegate?.updateLevel(level: currentLevel)
                showNextLevelLabel()
            }
            
            let reduceTime = Constants.reduceTimeToCreateFruit
            let reduceTimeRecreate = Constants.reduceTimeRecreate
            
            minTimeToMoveFruit -= (minTimeToMoveFruit > 2.66) ? reduceTime : 0
            maxTimeToMoveFruit -= (maxTimeToMoveFruit > 5.81) ? reduceTime : 0
            timeForRegenerateFruit -= (timeForRegenerateFruit > 0.75) ? reduceTimeRecreate : 0
        }
        
        if isRareFruit {
            timeDuration = CGFloat.random(in: 5.1...5.6)
        } else {
            timeDuration = CGFloat.random(in: minTimeToMoveFruit...maxTimeToMoveFruit)
        }
        return timeDuration
    }
    
    func showNextLevelLabel() {
        multiScoreLabel.isHidden = true
        nextLevelLabel.isHidden = false
        
        let actionFade = SKAction.fadeAlpha(to: 0, duration: 1.2)
        nextLevelLabel.run(actionFade) {
            self.nextLevelLabel.isHidden = true
            self.nextLevelLabel.alpha = 1.0
        }
    }
    
    func configureNextLevelMessage() {
        let text = GameText.getAttributedText(for: Constants.newLevel, size: 40.0, strokeWidth: -6.0, strokeColor: .orange)
        let position = CGPoint(x: frame.midX, y: frame.midY + 20)
        
        nextLevelLabel = SKLabelNode(attributedText: text)
        nextLevelLabel.position = position
        nextLevelLabel.isHidden = true
        nextLevelLabel.zPosition = 2
        addChild(nextLevelLabel)
    }
    
    func createHealth() {
        let scale = Constants.heartScale
        let currentHeart = Heart(sprite: Constants.heartNodeName, xScale: scale, yScale: scale)
        heart = HeartNode(currentHeart)
        heart.name = Constants.heartNodeName
        
        let min = -size.width / 2 + fruitCat.size.width / 2
        let max = size.width / 2 - fruitCat.size.width / 2
        let randomPos = GKRandomDistribution(lowestValue: Int(min), highestValue: Int(max))
        let xPos = CGFloat(randomPos.nextInt())
        let yPos = size.height / 2 + heart.size.height / 2
        
        heart.position = CGPoint(x: xPos, y: yPos)
        heart.zPosition = 1
        addChild(heart)
        
        let timeDuration = CGFloat.random(in: 5.5...6.2)
        let actionMove = SKAction.move(to: CGPoint(x: heart.position.x, y: -size.height / 2), duration: timeDuration)
        let actionMoveDone = SKAction.removeFromParent()
        let waitDuration = CGFloat.random(in: 4.0...7.0)
        let actionWait = SKAction.wait(forDuration: waitDuration)
        let actionAfterMoveDone = SKAction.run(generateHealth)
        let sequence = SKAction.sequence([actionMove, actionMoveDone, actionWait, actionAfterMoveDone])
        heart.run(sequence)
        animateRareItem(item: heart, originScale: scale)
    }
    
    func animateArrow(arrow: Arrow, state: ArrowState) {
        let originScale = Constants.arrowScale
        let reduceScale = originScale - (originScale * Constants.arrowPercentReduce / 100)
        let scale = (state == .reduce) ? reduceScale : originScale
        let actionScale = SKAction.scale(to: scale, duration: 0.15)
        let sequence = SKAction.sequence([actionScale])
        
        switch arrow {
        case .left:
            arrowLeft.run(sequence)
        case .right:
            arrowRight.run(sequence)
        }
    }
    
    func animateRareItem(item: SKSpriteNode, originScale: CGFloat) {
        let reduceScale = (originScale - (originScale * Constants.rareItemPercentReduce / 100)).rounded(toPlaces: 2)
        let increaseScale = (originScale + (originScale * Constants.rareItemPercentIncrease / 100)).rounded(toPlaces: 2)
        let actionScaleDown = SKAction.scale(to: reduceScale, duration: 0.4)
        let actionScaleUp = SKAction.scale(to: increaseScale, duration: 0.4)
        let sequence = SKAction.sequence([actionScaleDown, actionScaleUp])
        item.run(SKAction.repeatForever(sequence))
    }
    
    func pauseGame() {
        isPaused.toggle()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if leftButtonIsPressed {
            if let player = fruitCat as? FruitCatNode {
                player.movePlayer(.left, sceneSize: size)
            }
        }
        
        if rightButtonIsPressed {
            if let player = fruitCat as? FruitCatNode {
                player.movePlayer(.right, sceneSize: size)
            }
        }
    }
    
    func saveScores() {
        if currentScore > highScore {
            fruitsStorage.saveHighScore(currentScore)
        }
        
        if currentScore > (skinHighScore[playerSkin] ?? 0) {
            if let skinIndex = fruitSkins.firstIndex(where: { $0.type == playerSkin }) {
                fruitSkins[skinIndex].record = currentScore
            }
        }
        
        fruitsStorage.saveFruitsData(rareFruitsData)
        fruitsStorage.savePlayerSkin(fruitSkins)
    }
    
    func playCollectedSound() {
        if gameSounds {
            gameAudioPlayer?.playCollectedSound()
        }
    }
    
    func playGameOverSound() {
        if gameSounds {
            gameAudioPlayer?.playGameOverSound()
        }
    }
    
    func getScreenSize() -> CGSize {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        return window!.bounds.size
    }
}
