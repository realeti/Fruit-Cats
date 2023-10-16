//
//  GameAudio.swift
//  Fruit-Cats
//
//  Created by Apple M1 on 12.10.2023.
//

import AVFoundation

protocol GameAudioProtocol: AnyObject {
    var backgroundMusicPlayer: AVAudioPlayer? { get }
    var collectedSoundPlayer: AVAudioPlayer? { get }
    
    func prepareLoadAudio()
    func playBackgroundMusic()
    func playCollectedSound()
    func playGameOverSound()
    func playSwitchSkinSound()
    func playBuySkinSound()
    func stopBackgroundMusic()
}

enum GameAudioType: String {
    case mp3
    case wav
}

final class GameAudio: GameAudioProtocol {
    static let shared = GameAudio()
    
    var backgroundMusicPlayer: AVAudioPlayer?
    var collectedSoundPlayer: AVAudioPlayer?
    var switchSoundPlayer: AVAudioPlayer?
    var gameOverSoundPlayer: AVAudioPlayer?
    var buySkinSoundPlayer: AVAudioPlayer?
    
    func prepareLoadAudio() {
        
        // MARK: Background music
        let backgroundMusicUrl = Bundle.main.url(forResource: Constants.backgroundMusicName, withExtension: GameAudioType.mp3.rawValue)
        
        if let backgroundMusicUrl {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: backgroundMusicUrl)
                backgroundMusicPlayer?.volume = 0.35
                backgroundMusicPlayer?.numberOfLoops = -1
                backgroundMusicPlayer?.prepareToPlay()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // MARK: Collected sound
        let collectedSoundUrl = Bundle.main.url(forResource: Constants.collectedSoundName, withExtension: GameAudioType.mp3.rawValue)
        
        if let collectedSoundUrl {
            do {
                collectedSoundPlayer = try AVAudioPlayer(contentsOf: collectedSoundUrl)
                collectedSoundPlayer?.prepareToPlay()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        //MARK: Game over sound
        let gameOverSoundUrl = Bundle.main.url(forResource: Constants.gameOverSoundName, withExtension: GameAudioType.wav.rawValue)
        
        if let gameOverSoundUrl {
            do {
                gameOverSoundPlayer = try AVAudioPlayer(contentsOf: gameOverSoundUrl)
                gameOverSoundPlayer?.prepareToPlay()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // MARK: Switch skin sound
        let switchSkinSoundUrl = Bundle.main.url(forResource: Constants.switchSoundName, withExtension: GameAudioType.mp3.rawValue)
        
        if let switchSkinSoundUrl {
            do {
                switchSoundPlayer = try AVAudioPlayer(contentsOf: switchSkinSoundUrl)
                switchSoundPlayer?.prepareToPlay()
            } catch {
                print(error.localizedDescription)
            }
        }
        
        // MARK: Buy skin sound
        let buySkinSoundUrl = Bundle.main.url(forResource: Constants.buySkinSoundName, withExtension: GameAudioType.wav.rawValue)
        
        if let buySkinSoundUrl {
            do {
                buySkinSoundPlayer = try AVAudioPlayer(contentsOf: buySkinSoundUrl)
                buySkinSoundPlayer?.prepareToPlay()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func playBackgroundMusic() {
        backgroundMusicPlayer?.play()
    }
    
    func playCollectedSound() {
        collectedSoundPlayer?.stop()
        collectedSoundPlayer?.currentTime = 0.0
        collectedSoundPlayer?.play()
    }
    
    func playGameOverSound() {
        gameOverSoundPlayer?.play()
    }
    
    func playSwitchSkinSound() {
        switchSoundPlayer?.play()
    }
    
    func playBuySkinSound() {
        buySkinSoundPlayer?.play()
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
}
