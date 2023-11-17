//
//  Card.swift
//  Memo Game
//
//  Created by Ekaterina on 22.09.2023.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int { return identifier }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier : Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() ->Int {
        identifierFactory += 1
        return Card.identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
