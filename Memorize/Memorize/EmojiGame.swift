//
//  EmojiGame.swift - ViewModel
//  Memorize
//
//  Created by Anjalee Narenthiren on 2022-06-01.
//

import Foundation

class EmojiGame : ObservableObject {
    static let userDefaultsKey = "bestScoreForEachLevelKey"
    static let defaultBestScoreForEachLevel: [Int] = [Int.max, Int.max, Int.max, Int.max, Int.max, Int.max, Int.max]
    
    static var playGame : Bool = false

    
    let numPairsAtLevel : [Int] = [3, 6, 9, 12, 16, 20, emojis.count]
    
    private(set) var levelNumber : Int = 0
    
    enum LevelState {
        case stayOnThisLevel;
        case userDecidingToGoToNextLevel;
    }
    
    var levelState : LevelState = .stayOnThisLevel
    
    static var bestScoreForEachLevel: [Int] = restoreBestScoreArray()
    
    static func saveBestScore(level: Int, score: Int) {
        if (score < bestScoreForEachLevel[level]) {
            bestScoreForEachLevel[level] = score
        }
        UserDefaults.standard.set(bestScoreForEachLevel, forKey: userDefaultsKey)
    }
    
    static func restoreBestScoreArray() -> [Int] {
        // get bestScoreArray from memory if it exists & save it locally
        if let arr = UserDefaults.standard.array(forKey: userDefaultsKey) as? [Int] {
            return arr
        } else {
            return defaultBestScoreForEachLevel
        }
    }
    
    private  static let emojis = ["🥹","🫥","🫣","🎃","🤖","👾","👽","🥸","😍","🤯","🤡","😈","👻","👹","🙀","👩","👨‍🦰","👮‍♂️","🎅","🧛‍♂️","🧜‍♂️","🤱","🧚‍♂️"]
    
    private static func createMemoryGame(numPairs: Int) -> MemoryGame<String> {
        MemoryGame<String>(numPairs: numPairs) {
            pairIndex in
            emojis[pairIndex]
        }
    }
    
    // Add @Published keyword in front of model declaration. Now every time the model changes, it is "published" to the rest of the app.
    @Published private var model: MemoryGame<String> = createMemoryGame(numPairs: 3)
    
    var cards : [MemoryGame<String>.Card] {
        return model.cards
    }
    
    var numMatches : Int {
        return model.numMatches
    }
    
    var numMoves : Int {
        return model.numMoves
    }
    
    var minNumMoves : Int {
        return model.minNumMoves
    }
    
    func isLevelFinished() -> Bool {
        return model.numMatches >= model.numPairs
    }
    
    func choose (_ card : MemoryGame<String>.Card) {
        objectWillChange.send()
        model.choose(card)
        
        if (isLevelFinished() && levelNumber < 6) {
            EmojiGame.bestScoreForEachLevel = EmojiGame.restoreBestScoreArray()
            EmojiGame.saveBestScore(level: levelNumber, score: numMoves)
            print(EmojiGame.bestScoreForEachLevel)
            // When they finish the level, display button to ask user if they want to go to the next level
            levelState = .userDecidingToGoToNextLevel
        }
    }
    
    static func levelIsLocked(_ level: Int) -> Bool {
        level > 0 && EmojiGame.bestScoreForEachLevel[level - 1] == Int.max
    }
    
    func jumpToLevel(level: Int) {
        print("trying to jump to \(level)")
        if (!EmojiGame.levelIsLocked(level)) {
            levelNumber = level
            
            model = EmojiGame.createMemoryGame(numPairs: numPairsAtLevel[levelNumber])
            levelState = .stayOnThisLevel
            
            EmojiGame.playGame = true
            print(">> jump to \(level), playGame = \(EmojiGame.playGame)")
        }
    }
    
   func goToLevelMenu() {
       objectWillChange.send()
       levelNumber = 0
       EmojiGame.playGame = false
    }
    
    func goToNextLevel() {
        levelNumber += 1
        model = EmojiGame.createMemoryGame(numPairs: numPairsAtLevel[levelNumber])
        levelState = .stayOnThisLevel
    }
}
