//
//  Constants.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 02.10.2023.
//

import Foundation

struct Constants {
    
    // MARK: Storyboards
    static let gameScreenStoryboardName = "GameScreen"
    static let gameScreenStoryboardId = "GameScreen"
    
    static let recordScreenStoryboardName = "RecordScreen"
    static let recordScreenStoryboardId = "RecordScreen"
    
    static let settingsScreenStoryboardName = "SettingsScreen"
    static let settingsScreenStoryboardId = "SettingsScreen"
    
    static let pauseScreenStoryboardName = "PauseScreen"
    static let pauseScreenStoryboardId = "PauseScreen"
    
    static let gameOverScreenStoryboardName = "GameOverScreen"
    static let gameOverScreenStoryboardId = "GameOverScreen"
    
    static let buyButtonImage = "buy-button"
    static let buyButtonLockedImage = "buy-button-locked"
    
    // MARK: UserDefaults Storage
    static let fruitsKey = "fruits"
    static let fruitsCollectedKey = "collected"
    static let highScoreKey = "highScore"
    static let skinsKey = "skins"
    static let skinsLockedKey = "locked"
    static let skinsSelectedKey = "selected"
    static let skinsRecordKey = "record"
    static let soundKey = "sound"
    static let musicKey = "music"
    
    // MARK: Game Properties
    static let gameSceneName = "GameScene"
    static let gameOverSceneName = "GameOverScene"
    static let mainBackgroundImage = "gameBackground"
    static let leftButtonArrow = "arrow-left"
    static let rightButtonArrow = "arrow-right"
    static let heartNodeName = "heart"
    static let playerMoveDistance: CGFloat = 10.0
    static let minTimeToMoveFruit: CGFloat = 5.4
    static let maxTimeToMoveFruit: CGFloat = minTimeToMoveFruit + 2.4
    static let reduceTimeToCreateFruit: CGFloat = 0.25
    static let timeForRegenerateFruit: CGFloat = 1.75
    static let reduceTimeRecreate: CGFloat = 0.1
    static let rareFruitChance: Int = 5
    static let multiScoreValue: Int = 2
    
    // MARK: Sounds
    static let backgroundMusicName = "background"
    static let collectedSoundName = "collected"
    static let gameOverSoundName = "game-over"
    static let switchSoundName = "switch-skin"
    static let buySkinSoundName = "buy-skin"
    
    // MARK: Nodes sizes
    static let playerScale: CGFloat = 0.45
    static let arrowScale: CGFloat = 1.0
    static let fruitScale: CGFloat = 0.3
    static let heartScale: CGFloat = 0.8
    static let arrowPercentReduce: CGFloat = 12
    static let rareItemPercentReduce: CGFloat = 7
    static let rareItemPercentIncrease: CGFloat = 12
    
    // MARK: Buttons
    static let playButtonName = "Play"
    static let recordsButtonName = "Records"
    static let settingsButtonName = "Settings"
    static let mainMenuButtonName = "Main menu"
    static let playAgainButtonName = "Play again"
    static let buyButtonName = "Buy"
    static let buyButtonNameApply = "Apply"
    
    // MARK: Labels
    static let score = "Score"
    static let level = "LVL"
    static let newLevel = "New level!"
    static let pause = "Pause"
    static let bestRecords = "Best\nrecords"
    static let gameOver = "Game Over"
    static let settings = "Settings"
    static let music = "Music"
    static let sound = "Sound"
    static let fontName = "LuckiestGuy-Regular"
    
    // MARK: Shop
    static let priceBananaSkin = 100
    static let priceAppleSkin = 250
    static let priceStrawberrySkin = 300
    
    init () {}
}
