//
//  MainMenuScreenViewController.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 27.09.2023.
//

import UIKit
import AVFoundation

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordsButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    var fruitsStorage: FruitsStorageProtocol = FruitsStorage()
    var gameAudioPlayer: GameAudioProtocol = GameAudio.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        
        configurePlayButton()
        configureRecordsButton()
        configureSettingsButton()
        loadMusicData()
    }
    
    func configurePlayButton() {
        let titleText = Constants.playButtonName
        let title = GameText.getAttributedText(
            for: titleText,
            size: 40.0,
            strokeWidth: -5.0,
            strokeColor: .orange
        )
        playButton.setAttributedTitle(title, for: .normal)
    }
    
    func configureRecordsButton() {
        let titleText = Constants.recordsButtonName
        let title = GameText.getAttributedText(
            for: titleText,
            size: 40.0,
            strokeWidth: -5.0,
            strokeColor: .orange
        )
        recordsButton.setAttributedTitle(title, for: .normal)
    }
    
    func configureSettingsButton() {
        let titleText = Constants.settingsButtonName
        let title = GameText.getAttributedText(
            for: titleText,
            size: 40.0,
            strokeWidth: -5.0,
            strokeColor: .orange
        )
        settingsButton.setAttributedTitle(title, for: .normal)
    }
    
    func loadMusicData() {
        let playMusic = fruitsStorage.loadMusicData()
        gameAudioPlayer.prepareLoadAudio()
        
        if playMusic {
            gameAudioPlayer.playBackgroundMusic()
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.gameScreenStoryboardName, bundle: nil)
        if let gameVC = storyboard.instantiateViewController(withIdentifier: Constants.gameScreenStoryboardId) as? GameViewController {
            gameVC.gameAudioPlayer = gameAudioPlayer
            navigationController?.pushViewController(gameVC, animated: true)
        }
    }
    
    @IBAction func recordsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.recordScreenStoryboardName, bundle: nil)
        if let recordsVC = storyboard.instantiateViewController(withIdentifier: Constants.recordScreenStoryboardId) as? RecordViewController {
            navigationController?.pushViewController(recordsVC, animated: true)
        }
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.settingsScreenStoryboardName, bundle: nil)
        if let settingsVC = storyboard.instantiateViewController(withIdentifier: Constants.settingsScreenStoryboardId) as? SettingsViewController {
            settingsVC.gameAudioPlayer = gameAudioPlayer
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
}
