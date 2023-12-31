//
//  ViewController.swift
//  Memo Game
//
//  Created by Ekaterina on 12.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Consentration(numberOfPairsOfCards: numberOfPairesOfCards, numberOfDisplayedCards: DisplayedNumberOfCards)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in 0..<DisplayedNumberOfCards{
            cardButtons[index].backgroundColor = themeCardsColor
        }
        for index in DisplayedNumberOfCards..<cardButtons.count {
            cardButtons[index].isHidden = true
        }
        self.view.backgroundColor = themeBackGroundColor
    }
    
    private (set) var flipCount = 0 {
        didSet{
            updateLabel(label: flipCountLabel, text: "Flips: ", number: flipCount)
        }
    }
    
    private func updateLabel(label: UILabel, text: String, number: Int){
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: UIColor.purple
        ]
        let attributedString = NSAttributedString(string: "\(text) \(number)", attributes: attributes)
        label.attributedText = attributedString
    }
    
    var numberOfPairesOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            updateLabel(label: flipCountLabel, text: "Flips: ", number: flipCount)
        }
    }
    
    @IBOutlet weak var flipScore: UILabel!{
        didSet {
            updateLabel(label: flipScore, text: "Score: ", number: game.calculateScore)
        }
    }
    private var themeBackGroundColor: UIColor?
    private var themeCardsColor: UIColor?
    
    private var emojiChoices = ""
    private var emoji = [Card: String] ()

    var theme: (String?, UIColor?, UIColor?) {
        didSet {
            emojiChoices = theme.0 ?? ""
            emoji = [:]
            themeBackGroundColor = theme.1
            themeCardsColor = theme.2
            updateViewFromModel()
        }
    }
    
    private var DisplayedNumberOfCards: Int = 24
    
    var difficulty:Int = 24 {
        didSet{
            DisplayedNumberOfCards = difficulty
            updateViewFromModel()
        }
    }
        
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
        if cardButtons != nil {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                updateLabel(label: flipScore, text: "Score: ", number: game.calculateScore)
                button.setTitle(emoji(for: card),for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : themeCardsColor
            }
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
        emojiChoices = theme.0 ?? "?"
        game = Consentration(numberOfPairsOfCards: numberOfPairesOfCards, numberOfDisplayedCards: DisplayedNumberOfCards)
        game.calculateScore = 0
        flipCount = 0
        updateViewFromModel()
        updateLabel(label: flipScore, text: "Score: ", number: game.calculateScore)
    }
    
    @IBAction func shuffleCards(_ sender: Any) {
        game.shuffleCards(numberOfCards: DisplayedNumberOfCards)
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
