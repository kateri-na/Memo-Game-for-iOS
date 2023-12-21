//
//  Consentration.swift
//  Memo Game
//
//  Created by Ekaterina on 22.09.2023.
//

import Foundation

struct Consentration {
    
    private (set) var cards = [Card]()
    private (set) var usedClue = false;
    
    public var calculateScore = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func useClue() {
        usedClue = true
    }
    mutating func chooseCard(at index: Int){
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    calculateScore += 2
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                else {
                    calculateScore -= 1
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int, numberOfDisplayedCards: Int) {
        assert(numberOfPairsOfCards > 0, "Consentration.init(\(numberOfPairsOfCards)): must at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        shuffleCards(numberOfCards: numberOfDisplayedCards)
    }
    
    mutating func shuffleCards(numberOfCards: Int) {
        for index in 0..<numberOfCards{
            let rndIndex = Int(arc4random_uniform(UInt32(numberOfCards - index))) + index
            cards.swapAt(index, rndIndex)
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
