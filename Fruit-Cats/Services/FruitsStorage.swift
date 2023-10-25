//
//  FruitsStorage.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 02.10.2023.
//

import UIKit

protocol FruitsStorageProtocol {
    func loadFruitsData() -> [RareFruitProtocol]
    func saveFruitsData(_ fruits: [RareFruitProtocol])
    
    func loadHighScore() -> Int
    func saveHighScore(_ score: Int)
    
    func loadPlayerSkin() -> [SkinProtocol]
    func savePlayerSkin(_ skins: [SkinProtocol])
    
    func loadMusicData() -> Bool
    func saveMusicData(music: Bool)
    
    func loadSoundData() -> Bool
    func saveSoundData(sound: Bool)
}

class FruitsStorage: FruitsStorageProtocol {

    private let storage = UserDefaults.standard
    
    private let fruitsKey = Constants.fruitsKey
    private let fruitsCollectedKey = Constants.fruitsCollectedKey
    private let highScoreKey = Constants.highScoreKey
    private let skinsKey = Constants.skinsKey
    private let skinsLockedKey = Constants.skinsLockedKey
    private let skinsSelectedKey = Constants.skinsSelectedKey
    private let skinsRecordKey = Constants.skinsRecordKey
    private let soundKey = Constants.soundKey
    private let musicKey = Constants.musicKey
    
    func loadFruitsData() -> [RareFruitProtocol] {
        var resultFruits: [RareFruitProtocol] = []
        let fruitsFromStorage = storage.dictionary(forKey: fruitsKey) as? [String: [String: Int]] ?? [:]
        
        for (fruit, data) in fruitsFromStorage {
            guard let fruitCollected = data[fruitsCollectedKey] else {
                continue
            }
            
            if let fruitName = RareFruitsType(rawValue: fruit) {
                let rareFruit = RareFruit(type: fruitName, collected: fruitCollected)
                resultFruits.append(rareFruit)
            }
        }
        
        if resultFruits.isEmpty {
            resultFruits = RareFruitMock.getMockRareFruits
        }
        
        return resultFruits
    }
    
    func saveFruitsData(_ fruits: [RareFruitProtocol]) {
        var itemForStorage: [String: [String: Int]] = [:]
        
        for fruit in fruits {
            var newElementForStorage: Dictionary<String, Int> = [:]
            newElementForStorage[fruitsCollectedKey] = fruit.collected
            itemForStorage[fruit.type.rawValue] = newElementForStorage
        }
        storage.set(itemForStorage, forKey: fruitsKey)
    }
    
    func loadHighScore() -> Int {
        return storage.integer(forKey: highScoreKey)
    }
    
    func saveHighScore(_ score: Int) {
        storage.set(score, forKey: highScoreKey)
    }
    
    func loadPlayerSkin() -> [SkinProtocol] {
        var resultSkins: [SkinProtocol] = []
        let skinsFromStorage = storage.dictionary(forKey: skinsKey) as? [String: [String: Int]] ?? [:]
        
        for (skin, data) in skinsFromStorage {
            guard let skinIsLocked = data[skinsLockedKey],
                  let skinIsSelected = data[skinsSelectedKey],
                  let skinRecord = data[skinsRecordKey] else {
                continue
            }
            
            if let skinName = SkinType(rawValue: skin) {
                let skin = Skin(type: skinName, isLocked: skinIsLocked.boolValue, isSelected: skinIsSelected.boolValue, record: skinRecord)
                resultSkins.append(skin)
            }
        }
        
        if resultSkins.isEmpty {
            resultSkins = SkinsMock.getSkinsMock
        }
        
        resultSkins.sort {
            let skin1 = SkinType.allCases.firstIndex(of: $0.type) ?? 0
            let skin2 = SkinType.allCases.firstIndex(of: $1.type) ?? 0
            
            return skin1 < skin2
        }
        
        return resultSkins
    }
    
    func savePlayerSkin(_ skins: [SkinProtocol]) {
        var itemForStorage: [String: [String: Int]] = [:]
        
        for skin in skins {
            var newElementForStorage: Dictionary<String, Int> = [:]
            newElementForStorage[skinsLockedKey] = skin.isLocked.intValue
            newElementForStorage[skinsSelectedKey] = skin.isSelected.intValue
            newElementForStorage[skinsRecordKey] = skin.record
            itemForStorage[skin.type.rawValue] = newElementForStorage
        }
        storage.set(itemForStorage, forKey: skinsKey)
    }
    
    func loadMusicData() -> Bool {
        storage.register(defaults: [musicKey: true])
        return storage.bool(forKey: musicKey)
    }
    
    func saveMusicData(music: Bool) {
        storage.set(music, forKey: musicKey)
    }
    
    func loadSoundData() -> Bool {
        storage.register(defaults: [soundKey: true])
        return storage.bool(forKey: soundKey)
    }
    
    func saveSoundData(sound: Bool) {
        storage.set(sound, forKey: soundKey)
    }
}
