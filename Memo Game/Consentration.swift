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
    
    init(numberOfPairsOfCards: Int, numberOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Consentration.init(\(numberOfPairsOfCards)): must at least one pair of cards")
        let AllNumberOfPairsOfCards: Int = (numberOfCards+1) / 2
        for _ in 1...AllNumberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        for index in numberOfPairsOfCards*2..<numberOfCards {
            cards[index].isMatched = true
        }
        shuffleCards(numberOfDisplayedPairs: numberOfPairsOfCards)
    }
    
    mutating func shuffleCards(numberOfDisplayedPairs: Int) {
        let numberOfDisplayedCards: Int = numberOfDisplayedPairs * 2
        for index in 0..<numberOfDisplayedCards{
            let rndIndex = Int(arc4random_uniform(UInt32(numberOfDisplayedCards - index))) + index
            cards.swapAt(index, rndIndex)
        }
//        cards.shuffle()
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
