//
//  RecordViewController.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 11.10.2023.
//

import UIKit

class RecordViewController: UIViewController {
    
    @IBOutlet weak var bestRecordsLabel: UILabel!
    @IBOutlet weak var bestScoreLabel: UILabel!
    @IBOutlet weak var bananaScoreLabel: UILabel!
    @IBOutlet weak var appleScoreLabel: UILabel!
    @IBOutlet weak var strawberryScoreLabel: UILabel!
    
    var fruitsStorage: FruitsStorageProtocol = FruitsStorage()
    var recordSkins: [SkinType: Int] = [:]
    var bestScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadFruitsData()
        configureBestRecordsLabel()
        configureBestScoreLabel()
        configureFruitsScoreLabels()
    }
    
    func loadFruitsData() {
        bestScore = fruitsStorage.loadHighScore()
        
        fruitsStorage.loadPlayerSkin().forEach { skin in
            recordSkins[skin.type] = skin.record
        }
    }
    
    func configureBestRecordsLabel() {
        let bestRecordsText = Constants.bestRecords
        let text = GameText.getAttributedText(
            for: bestRecordsText,
            size: 42.0,
            strokeWidth: -5.0,
            strokeColor: .orange
        )
        bestRecordsLabel.attributedText = text
    }
    
    func configureBestScoreLabel() {
        let bestScoreText = "\(bestScore)"
        let text = GameText.getAttributedText(
            for: bestScoreText,
            size: 35.0,
            strokeWidth: -6.0,
            strokeColor: .orange
        )
        bestScoreLabel.attributedText = text
    }
    
    func configureFruitsScoreLabels() {
        let bananaScore = "\(Constants.score): \(recordSkins[.banana] ?? 0)"
        configureFruitScoreLabel(bananaScoreLabel, textLabel: bananaScore)
        
        let appleScore = "\(Constants.score): \(recordSkins[.apple] ?? 0)"
        configureFruitScoreLabel(appleScoreLabel, textLabel: appleScore)
        
        let strawberryScore = "\(Constants.score): \(recordSkins[.strawberry] ?? 0)"
        configureFruitScoreLabel(strawberryScoreLabel, textLabel: strawberryScore)
    }
    
    func configureFruitScoreLabel(_ label: UILabel, textLabel: String) {
        let text = GameText.getAttributedText(
            for: textLabel,
            size: 20,
            strokeWidth: -6.0,
            strokeColor: .orange
        )
        label.attributedText = text
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
