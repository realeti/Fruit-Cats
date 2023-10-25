//
//  SettingsViewController.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 06.10.2023.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var placeSkinView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var skinImage: UIImageView!
    @IBOutlet weak var priceImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var arrowLeftButton: UIButton!
    @IBOutlet weak var arrowRightButton: UIButton!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var bananaCollectedView: UIView!
    @IBOutlet weak var appleCollectedView: UIView!
    @IBOutlet weak var strawberryCollectedView: UIView!
    @IBOutlet weak var bananaCollectedLabel: UILabel!
    @IBOutlet weak var appleCollectedLabel: UILabel!
    @IBOutlet weak var strawberryCollectedLabel: UILabel!
    
    var fruitsStorage: FruitsStorageProtocol = FruitsStorage()
    var fruitSkins: [SkinProtocol] = []
    var rareFruitsData: [RareFruitProtocol] = []
    var collectedFruits: [RareFruitsType: Int] = [:]
    var skinPrices: [SkinType: Int] = [:]
    var selectedSkinIndex = 0
    var gameMusic = true {
        didSet {
            
        }
    }
    var gameSounds = true
    
    let priceBananaSkin = Constants.priceBananaSkin
    let priceAppleSkin = Constants.priceAppleSkin
    let priceStrawberrySkin = Constants.priceStrawberrySkin
    
    weak var gameAudioPlayer: GameAudioProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skinPrices[.banana] = Constants.priceBananaSkin
        skinPrices[.apple] = Constants.priceAppleSkin
        skinPrices[.strawberry] = Constants.priceStrawberrySkin
        
        loadSkinsData()
        loadFruitsData()
        loadMusicData()
        loadSoundData()
        configureSettingsLabel()
        configueMusicLabel()
        configureSoundLabel()
        configureMusicSwitch()
        configureSoundSwitch()
        configurePlaceSkinView()
        configureFruitViews()
        updateCollectedLabels()
        configureSkinImage()
    }
    
    func loadSkinsData() {
        fruitSkins = fruitsStorage.loadPlayerSkin()
        
        for (index, skin) in fruitSkins.enumerated() {
            if skin.isSelected {
                selectedSkinIndex = index
                break
            }
        }
    }
    
    func loadFruitsData() {
        rareFruitsData = fruitsStorage.loadFruitsData()
        
        rareFruitsData.forEach { rareFruit in
            collectedFruits[rareFruit.type] = rareFruit.collected
        }
    }
    
    func loadMusicData() {
        gameMusic = fruitsStorage.loadMusicData()
    }
    
    func loadSoundData() {
        gameSounds = fruitsStorage.loadSoundData()
    }
    
    func configureSettingsLabel() {
        let settingsText = Constants.settings
        let text = GameText.getAttributedText(
            for: settingsText,
            size: 40.0,
            strokeWidth: -5.0,
            strokeColor: .orange
        )
        settingsLabel.attributedText = text
    }
    
    func configueMusicLabel() {
        let musicText = Constants.music
        let text = GameText.getAttributedText(
            for: musicText,
            size: 30.0,
            strokeWidth: -4.0,
            strokeColor: .orange
        )
        musicLabel.attributedText = text
    }
    
    func configureSoundLabel() {
        let soundText = Constants.sound
        let text = GameText.getAttributedText(
            for: soundText,
            size: 30.0,
            strokeWidth: -4.0,
            strokeColor: .orange
        )
        soundLabel.attributedText = text
    }
    
    func configureMusicSwitch() {
        musicSwitch.isOn = gameMusic
        musicSwitch.onTintColor = UIColor(red: 1.0, green: 123.0/255.0, blue: 0.0, alpha: 1.0)
        musicSwitch.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
    }
    
    func configureSoundSwitch() {
        soundSwitch.isOn = gameSounds
        soundSwitch.onTintColor = UIColor(red: 1.0, green: 123.0/255.0, blue: 0.0, alpha: 1.0)
        soundSwitch.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
    }
    
    func configurePlaceSkinView() {
        placeSkinView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        placeSkinView.layer.cornerRadius = 12
        placeSkinView.layer.borderColor = UIColor.black.cgColor
        placeSkinView.layer.borderWidth = 0.5
    }
    
    func configureFruitViews() {
        configureFruitView(priceView, cornerRadius: 7, borderWidth: 0.5)
        configureFruitView(bananaCollectedView, cornerRadius: 7, borderWidth: 0.5)
        configureFruitView(appleCollectedView, cornerRadius: 7, borderWidth: 0.5)
        configureFruitView(strawberryCollectedView, cornerRadius: 7, borderWidth: 0.5)
    }
    
    func configureFruitView(_ fruitView: UIView, cornerRadius: CGFloat, borderWidth: CGFloat) {
        fruitView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        fruitView.layer.cornerRadius = 7
        fruitView.layer.borderColor = UIColor.black.cgColor
        fruitView.layer.borderWidth = 0.5
    }
    
    func updateCollectedLabels() {
        configureCollectedLabel(bananaCollectedLabel, textLabel: "\(collectedFruits[.banana] ?? 0)")
        configureCollectedLabel(appleCollectedLabel, textLabel: "\(collectedFruits[.apple] ?? 0)")
        configureCollectedLabel(strawberryCollectedLabel, textLabel: "\(collectedFruits[.strawberry] ?? 0)")
    }
    
    func configureCollectedLabel(_ label: UILabel, textLabel: String) {
        let text = GameText.getAttributedText(
            for: textLabel,
            size: 18.0,
            strokeWidth: 0.0,
            strokeColor: .none
        )
        label.attributedText = text
    }
    
    func configureSkinImage() {
        let selectedSkin = fruitSkins[selectedSkinIndex]
        let imageSkin = selectedSkin.type.rawValue
        skinImage.image = UIImage(named: imageSkin)
        
        updateArrowButtons()
        updatePriceImage()
        updatePriceLabel()
        updateBuyButton()
    }
    
    func updateArrowButtons() {
        arrowLeftButton.isEnabled = (selectedSkinIndex == 0) ? false : true
        arrowRightButton.isEnabled = (selectedSkinIndex == fruitSkins.count - 1) ? false : true
    }
    
    func updatePriceImage() {
        let rareFruits = RareFruitsType.allCases
        let currentRareFruit = rareFruits[selectedSkinIndex].rawValue
        priceImage.image = UIImage(named: currentRareFruit)
    }
    
    func updatePriceLabel() {
        let skinType = SkinType.allCases[selectedSkinIndex]
        let skinPrice = skinPrices[skinType] ?? 0
        
        let priceText = "\(skinPrice)"
        let text = GameText.getAttributedText(
            for: priceText,
            size: 22.0,
            strokeWidth: 0.0,
            strokeColor: .none
        )
        priceLabel.attributedText = text
    }
    
    func updateBuyButton() {
        let selectedSkin = fruitSkins[selectedSkinIndex]
        let fruitType = RareFruitsType.allCases[selectedSkinIndex]
        
        let skinPrice = skinPrices[selectedSkin.type] ?? 0
        let fruits = collectedFruits[fruitType] ?? 0
        
        if selectedSkin.isLocked && fruits < skinPrice {
            buyButton.setBackgroundImage(UIImage(named: Constants.buyButtonLockedImage), for: .normal)
            buyButton.isUserInteractionEnabled = false
            lockImage.isHidden = false
        } else if selectedSkin.isLocked && fruits >= skinPrice {
            buyButton.setBackgroundImage(UIImage(named: Constants.buyButtonImage), for: .normal)
            buyButton.isUserInteractionEnabled = true
            lockImage.isHidden = true
        } else if selectedSkin.isSelected {
            buyButton.setBackgroundImage(UIImage(named: Constants.buyButtonLockedImage), for: .normal)
            buyButton.isUserInteractionEnabled = false
            lockImage.isHidden = true
        } else {
            buyButton.setBackgroundImage(UIImage(named: Constants.buyButtonImage), for: .normal)
            buyButton.isUserInteractionEnabled = true
            lockImage.isHidden = true
        }
        
        configureBuyButtonTitle(selectedSkin)
    }
    
    func configureBuyButtonTitle(_ selectedSkin: SkinProtocol) {
        let titleText = (selectedSkin.isLocked) ? Constants.buyButtonName : Constants.buyButtonNameApply
        let strokeColor = (selectedSkin.isLocked || selectedSkin.isSelected) ? StrokeColor.gray : StrokeColor.blue
        let title = GameText.getAttributedText(
            for: titleText,
            size: 26,
            strokeWidth: -5.0,
            strokeColor: strokeColor
        )
        buyButton.setAttributedTitle(title, for: .normal)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buyButtonPressed(_ sender: UIButton) {
        let selectedSkin = fruitSkins[selectedSkinIndex]
        let fruitType = RareFruitsType.allCases[selectedSkinIndex]
        
        if selectedSkin.isLocked {
            buyNewSkin(selectedSkin, fruitType)
        } else {
            chooseNewSkin(selectedSkin, fruitType)
        }
    }
    
    func buyNewSkin(_ selectedSkin: SkinProtocol, _ fruitType: RareFruitsType) {
        playBuySkinSound()
        
        let skinPrice = skinPrices[selectedSkin.type] ?? 0
        
        if let fruitIndex = rareFruitsData.firstIndex(where: { $0.type == fruitType }) {
            rareFruitsData[fruitIndex].collected -= skinPrice
        }
        
        if let currentFruits = collectedFruits[fruitType] {
            collectedFruits[fruitType] = currentFruits - skinPrice
        }
        
        fruitSkins[selectedSkinIndex].isLocked = false
        
        updateCollectedLabels()
        updateBuyButton()
        fruitsStorage.saveFruitsData(rareFruitsData)
        fruitsStorage.savePlayerSkin(fruitSkins)
    }
    
    func chooseNewSkin(_ selectedSkin: SkinProtocol, _ fruitType: RareFruitsType) {
        playSwitchSkinSound()
        
        for index in 0...fruitSkins.count - 1 {
            if index == selectedSkinIndex {
                fruitSkins[index].isSelected = true
                continue
            }
            
            fruitSkins[index].isSelected = false
        }
        
        fruitsStorage.savePlayerSkin(fruitSkins)
        updateBuyButton()
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        if selectedSkinIndex > 0 {
            playSwitchSkinSound()
            
            selectedSkinIndex -= 1
            configureSkinImage()
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        if selectedSkinIndex < fruitSkins.count - 1 {
            playSwitchSkinSound()
            
            selectedSkinIndex += 1
            configureSkinImage()
        }
    }
    
    @IBAction func musicSwitchPressed(_ sender: UISwitch) {
        gameMusic = sender.isOn
        fruitsStorage.saveMusicData(music: gameMusic)
        
        if gameMusic {
            gameAudioPlayer?.playBackgroundMusic()
        } else {
            gameAudioPlayer?.stopBackgroundMusic()
        }
    }
    
    @IBAction func soundSwitchPressed(_ sender: UISwitch) {
        gameSounds = sender.isOn
        fruitsStorage.saveSoundData(sound: gameSounds)
    }
    
    func playSwitchSkinSound() {
        if gameSounds {
            gameAudioPlayer?.playSwitchSkinSound()
        }
    }
    
    func playBuySkinSound() {
        if gameSounds {
            gameAudioPlayer?.playBuySkinSound()
        }
    }
}
