//
//  HatViewController.swift
//  HogwartsApp
//
//  Created by Daniel Washington Ignacio on 01/09/21.
//

import UIKit

class HatViewController: UIViewController {
    
    var nameHouse:[String] = ["Grifinória", "Sonserina","Corvinal", "Lufa-lufa"]
    
    @IBOutlet weak var textHouse: UILabel!
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var hatImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var suffleButton: ButtonGradient!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        suffleButton.layer.cornerRadius = suffleButton.frame.height / 2
        nameTextField.setEditingColor()
        title = "Chapéu Seletor"
        titleLabel.isHidden = true
    }
    
    @IBAction func luckButton(_ sender: UIButton) {
        print("Cliked")
        
        nameHouse.shuffle()
        
        self.viewMain.firstColor = self.backgroundColor(name: nameHouse.first ?? "")
        self.textHouse.text = "Sua casa sorteada foi: \(nameHouse.first ?? "")"
    }
    
    func backgroundColor(name: String) -> UIColor {
        print(name)
        
        switch name {
        case "Grifinória":
            return UIColor(red: 0.48, green: 0.04, blue: 0.08, alpha: 1.00)
        case "Lufa-lufa":
            return UIColor(red: 0.95, green: 0.69, blue: 0.10, alpha: 1.00)
        case "Corvinal":
            return UIColor(red: 0.20, green: 0.32, blue: 0.52, alpha: 1.00)
        case "Sonserina":
            return UIColor(red: 0.03, green: 0.24, blue: 0.14, alpha: 1.00)
        default:
            return .black
        }
    }
    
    func saveHouse(){
        
        let value = UserDefaults.standard.string(forKey: "myHouse")

        UserDefaults.standard.set(nameHouse.first, forKey: "myHouse")
        print("myHouse")
    }
}
