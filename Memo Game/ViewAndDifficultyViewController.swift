//
//  ViewAndDifficultyViewController.swift
//  Memo Game
//
//  Created by Ekaterina on 28.11.2023.
//

import UIKit

class ViewAndDifficultyViewController: UIViewController {
      
    @IBOutlet weak var ThemeLabel: UILabel!{
        didSet{
            UpdateLabel(label: ThemeLabel, text: "Theme:")
        }
    }
    
    @IBOutlet weak var DifficultyLabel: UILabel!{
        didSet{
            UpdateLabel(label: DifficultyLabel, text: "Difficulty:")
        }
    }
    
    private func UpdateLabel(label: UILabel, text: String){
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: 8.0,
            .strokeColor: UIColor.darkGray
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        label.attributedText = attributedString
    }
    
    var choosenTheme: (String, UIColor, UIColor) = ("🐶🐣🐭🦊🐼🐹🐸🐻🐰🦁🐮🐷", .yellow, .green)
    
    var choosenDifficulty: Int = 8

    let Theme = [
        "Animals", "Flags", "Food", "Random"
    ]
    
    let Difficulty = ["8 cards", "12 cards", "24 cards"]
    
    let Themes = [
        "Animals" : ("🐶🐣🐭🦊🐼🐹🐸🐻🐰🦁🐮🐷", UIColor.yellow, UIColor.green),
        "Flags" : ("🇹🇴🇫🇮🇬🇫🇺🇬🇨🇫🇯🇵🇬🇧🇹🇱🇻🇮🇱🇧🇷🇪🇸🇿", UIColor.black, UIColor.cyan),
        "Food" : ("🍙🍡🍇🥥🧀🥟🌮🍱🥘🥗🥦🥞", UIColor.red, UIColor.blue)
    ]
    
    let Diffuculties = [
        "8 cards" : 8,
        "12 cards" : 12,
        "24 cards" : 24,
    ]
    
    private func RandomTheme() -> (String, UIColor, UIColor){
        let key: String = Themes.keys.randomElement()!
        return Themes[key]!
    }
        
    @IBOutlet weak var ChooseThemePickerView: UIPickerView!
    
    @IBOutlet weak var ChooseDifficultyPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ChooseThemePickerView.delegate = self
        ChooseThemePickerView.dataSource = self
        
        ChooseDifficultyPickerView.delegate = self
        ChooseDifficultyPickerView.dataSource = self
        
        ChooseThemePickerView.tag = 1
        ChooseDifficultyPickerView.tag = 2
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "Get Info" {
            if let cvc = segue.destination as? ViewController {
                cvc.theme = choosenTheme
                cvc.difficulty = choosenDifficulty
            }
        }
    }
}

extension ViewAndDifficultyViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return Theme.count
        case 2:
            return Difficulty.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return Theme[row]
        case 2:
            return Difficulty[row]
        default:
            return "?"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            if Theme[row] == "Random" {
                choosenTheme = RandomTheme()
            }
            else {
                choosenTheme = Themes[Theme[row]]!
            }
        case 2:
            choosenDifficulty = Diffuculties[Difficulty[row]] ?? 0
        default:
            print("?")
        }
    }
}
