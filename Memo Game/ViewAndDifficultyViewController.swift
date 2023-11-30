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
    
    let Theme = ["Animals", "Flags", "Food", "Random"]
    let Difficulty = ["8 cards", "12 cards", "24 cards"]
    
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
    
    @IBAction func ShowCards(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ViewController")
        self.present(viewController, animated: false, completion: nil)
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
}
