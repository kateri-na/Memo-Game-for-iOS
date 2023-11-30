//
//  ViewController.swift
//  Memo Game
//
//  Created by Ekaterina on 12.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Consentration(numberOfPairsOfCards: numberOfPairesOfCards)
    
    private (set) var flipCount = 0 {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel () {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.purple
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateFlipScoreLabel(){
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.purple
        ]
        let attributedString = NSAttributedString(string: "Score: \(game.calculateScore)", attributes: attributes)
        flipScore.attributedText = attributedString
    }
    
    var numberOfPairesOfCards: Int {
            return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet weak var flipScore: UILabel!{
        didSet {
            updateFlipScoreLabel()
        }
    }
    
    private var emojiChoices = "🐶🐣🐭🦊🐼🐹"
    
    private var emoji = [Card: String] ()
        
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount+=1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print ("Your card out of range")
        }
    }

    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                updateFlipScoreLabel()
                button.setTitle(emoji(for: card),for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            }
        }
    }
    
    private func updateClueView(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if !card.isMatched {
                button.setTitle(emoji(for: card),for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            }
        return emoji[card] ?? "?"
    }
    
    @IBAction func startNewGame(_ sender: Any) {
        emojiChoices = "🐶🐣🐭🦊🐼🐹"
        game = Consentration(numberOfPairsOfCards: numberOfPairesOfCards)
        game.calculateScore = 0
        flipCount = 0
        updateViewFromModel()
        updateFlipScoreLabel()
    }
    
    @IBAction func shuffleCards(_ sender: Any) {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    @IBAction func getClue(_ sender: Any) {
        if !game.usedClue {
            game.useClue()
            updateClueView()
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false){
                timer in self.updateViewFromModel()
            }
        }
    }
        
}
    
extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
