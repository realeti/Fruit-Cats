//
//  PauseViewController.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 06.10.2023.
//

import UIKit

class PauseViewController: UIViewController {
    
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    weak var delegate: PauseProtocol?
    weak var gameAudioPlayer: GameAudioProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        configurePauseLabel()
        configureMainMenuButton()
        configureSettingsButton()
    }
    
    func configurePauseLabel() {
        let pauseText = Constants.pause
        let text = GameText.getAttributedText(
            for: pauseText,
            size: 40.0,
            strokeWidth: -5.0,
            strokeColor: .orange
        )
        pauseLabel.attributedText = text
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
    
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        delegate?.resumeGame()
    }
    
    @IBAction func mainMenuButtonPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Constants.settingsScreenStoryboardName, bundle: nil)
        if let settingsVC = storyboard.instantiateViewController(withIdentifier: Constants.settingsScreenStoryboardId) as? SettingsViewController {
            settingsVC.gameAudioPlayer = gameAudioPlayer
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
}
