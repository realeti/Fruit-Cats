//
//  GameViewController.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 24.09.2023.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageHeartPlace: UIImageView!
    @IBOutlet weak var imageHeart1: UIImageView!
    @IBOutlet weak var imageHeart2: UIImageView!
    @IBOutlet weak var imageHeart3: UIImageView!
    @IBOutlet weak var pauseButton: UIButton!
    
    var gameScene: GameScene?
    var pauseViewController: PauseViewController?
    weak var gameAudioPlayer: GameAudioProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScoreLabel()
        configureHeartPlace()
        
        loadGameScene()
        setupPauseViewController()
    }
    
    func configureScoreLabel(score: Int = 0) {
        let scoreText = "\(Constants.score): \(score)"
        let text = GameText.getAttributedText(
            for: scoreText,
            size: 25.0,
            strokeWidth: -6.0,
            strokeColor: .orange
        )
        scoreLabel.attributedText = text
    }
    
    func configureHeartPlace() {
        imageHeartPlace.alpha = 0.8
    }
    
    func loadGameScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: Constants.gameSceneName) as? GameScene {
                // Set the scale mode to scale to fit the window
                gameScene = scene
                scene.scaleMode = .resizeFill
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                scene.sceneDelegate = self
                scene.gameAudioPlayer = gameAudioPlayer
                
                view.presentScene(scene)
            }
            
            //view.showsPhysics = true
            view.ignoresSiblingOrder = true
        }
    }
    
    func setupPauseViewController() {
        let storyboard = UIStoryboard(name: Constants.pauseScreenStoryboardName, bundle: nil)
        if let pauseVC = storyboard.instantiateViewController(withIdentifier: Constants.pauseScreenStoryboardId) as? PauseViewController {
            pauseVC.gameAudioPlayer = gameAudioPlayer
            pauseViewController = pauseVC
        }
    }
    
    @IBAction func pauseButtonPressed(_ sender: UIButton) {
        pauseGame()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: GameSceneProtocol {
    func updateScore(score: Int) {
        configureScoreLabel(score: score)
    }
    
    func updateHearts(heart: HeartList, isSubtract: Bool) {
        switch heart {
        case .heart1:
            imageHeart1.isHidden = isSubtract
        case .heart2:
            imageHeart2.isHidden = isSubtract
        case .heart3:
            imageHeart3.isHidden = isSubtract
        }
    }
    
    func pauseGame() {
        gameScene?.pauseGame()
        
        if let pauseViewController {
            showPauseScreen(pauseViewController)
        }
    }
    
    func showPauseScreen(_ viewController: PauseViewController) {
        viewController.delegate = self
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
    }
    
    func loadGameOverScene(score: Int) {
        let storyboard = UIStoryboard(name: Constants.gameOverScreenStoryboardName, bundle: nil)
        if let gameOverVC = storyboard.instantiateViewController(withIdentifier: Constants.gameOverScreenStoryboardId) as? GameOverViewController {
            gameOverVC.delegate = self
            gameOverVC.currentScore = score
            navigationController?.pushViewController(gameOverVC, animated: true)
        }
    }
}

extension GameViewController: PauseProtocol {
    func resumeGame() {
        gameScene?.pauseGame()
        gameScene?.loadSoundData()
        
        if let pauseViewController {
            hidePauseScreen(pauseViewController)
        }
    }
    
    func hidePauseScreen(_ viewController: PauseViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

extension GameViewController: GameOverProtocol {
    func resetGameData() {
        configureScoreLabel()
        imageHeart1.isHidden = false
        imageHeart2.isHidden = false
        imageHeart3.isHidden = false
    }
    
    func startNewGame() {
        loadGameScene()
    }
}
