//
//  MemoryGame.swift - Model
//  Memorize
//
//  Created by Anjalee Narenthiren on 2022-06-01.
//

import Foundation

struct MemoryGame<ContentType> where ContentType : Equatable {
    
    // Array of cards
    private(set) var cards : [Card]
    
    // Num of pairs of cards
    let numPairs : Int
    
    // Global Score Variables
    private(set) var numMatches : Int = 0
    private(set) var numMoves : Int = 0
    private(set) var minNumMoves : Int = Int.max
    
    // Index of single card faceup on screen (nil when there are two cards face up)
    private var indexOfSingleFaceUpCard : Int?
    
    // Constructor
    init(numPairs : Int, getContent : (Int) -> ContentType) {
        self.numPairs = numPairs
        cards = Array<Card>()
        for pairIndex in 0..<numPairs {
            cards.append(Card(id: pairIndex * 2, content: getContent(pairIndex)))
            cards.append(Card(id: (pairIndex * 2) + 1, content: getContent(pairIndex)))
        }
        
        // Shuffle the cards
        cards.shuffle()
    }
    
    // Func to choose a card (flips it and see if it matches)
    mutating func choose (_ card: Card) {
        // Make sure card exists in our deck, and it hasn't already been matched or flipped
        if let cardIndex : Int = cards.firstIndex(where: {$0.id == card.id}), !cards[cardIndex].isMatched, cardIndex != indexOfSingleFaceUpCard {
            // If there are 0 or 2 cards face up, reset all unmatched cards to be face down
            if (indexOfSingleFaceUpCard == nil) {
                for i in cards.indices {
                    if (!cards[i].isMatched) {
                        cards[i].isFaceUp = false
                    }
                }
                indexOfSingleFaceUpCard = cardIndex
            }
            // Now there are two cards that have been selected
            else {
                    numMoves += 1
                
                    // Check if the selected cards match, and they are unique
                    if let otherCardIndex = indexOfSingleFaceUpCard, otherCardIndex != cardIndex, cards[otherCardIndex].content == cards[cardIndex].content {
                        cards[cardIndex].isMatched = true
                        cards[otherCardIndex].isMatched = true
                        
                        numMatches += 1
                        
                        // Set minNumMoves once we have matched all pairs
                        if (numMatches >= numPairs && numMoves < minNumMoves) {
                            minNumMoves = numMoves
                            print (minNumMoves)
                        }
//                        print(numMatches)
                    }
                indexOfSingleFaceUpCard = nil
            }
            cards[cardIndex].isFaceUp.toggle()
//            print ("cardInArray = \(cards[cardIndex])")
        }
    }
    
    
    // Func to increment global score
    
    
    struct Card : Identifiable {
        let id: Int
        
        var isFaceUp : Bool = false
        var isMatched : Bool = false
        let content : ContentType
    }
 
}
