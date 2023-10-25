//
//  GameOverViewController.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 05.10.2023.
//

import UIKit
import SpriteKit

class GameOverViewController: UIViewController {

    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var mainMenuButton: UIButton!
    
    weak var delegate: GameOverProtocol?
    var currentScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGameOverLabel()
        configureScoreLabel()
        configurePlayAgainButton()
        configureMainMenuButton()
        loadGameOverScene()
    }
    
    func configureGameOverLabel() {
        let gameOverText = Constants.gameOver
        let text = GameText.getAttributedText(
            for: gameOverText,
            size: 40.0,
            strokeWidth: -5.0,
            strokeColor: .orange
        )
        gameOverLabel.attributedText = text
    }
    
    func configureScoreLabel() {
        let scoreText = "\(Constants.score): \(currentScore)"
        let text = GameText.getAttributedText(
            for: scoreText,
            size: 30.0,
            strokeWidth: -6.0,
            strokeColor: .orange
        )
        currentScoreLabel.attributedText = text
    }
    
    func configurePlayAgainButton() {
        let titleText = Constants.playAgainButtonName
        let title = GameText.getAttributedText(
            for: titleText,
            size: 40.0,
            strokeWidth: -5.0,
            strokeColor: .orange
        )
        playAgainButton.setAttributedTitle(title, for: .normal)
    }
    
    func configureMainMenuButton() {
        let titleText = Constants.mainMenuButtonName
        let title = GameText.getAttributedText(
            for: titleText,
            size: 40.0,
            strokeWidth: -5.0,
            strokeColor: .orange
        )
        mainMenuButton.setAttributedTitle(title, for: .normal)
    }
    
    func loadGameOverScene() {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: Constants.gameOverSceneName) as? GameOverScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
        }
    }
    
    @IBAction func playAgainButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        delegate?.resetGameData()
        delegate?.startNewGame()
    }
    
    @IBAction func mainMenuButtonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
