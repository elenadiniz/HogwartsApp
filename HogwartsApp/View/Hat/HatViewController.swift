//
//  HatViewController.swift
//  HogwartsApp
//
//  Created by Daniel Washington Ignacio on 01/09/21.
//

import UIKit

protocol myHouseDelegate {
    var myHouse: String { get }
}

class HatViewController: UIViewController, myHouseDelegate {
    
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var hatImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var houseLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var suffleButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var myHouse: String = ""
    var nameHouse:[String] = ["Grifinória", "Sonserina","Corvinal", "Lufa-lufa"]
    var houseSelected: String = ""
    var house: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let value = UserDefaults.standard.string(forKey: "myHouse")

        for user in value ?? "" {
            self.nameTextField.isHidden = true
            self.infoLabel.isHidden = true
            self.houseSelected = nameHouse.first ?? ""
            self.viewMain.firstColor = self.backgroundColor(name: value ?? "")
            self.viewSuccess.isHidden = false
            self.houseLabel.text = "\(value ?? "")"
            self.houseLabel.textColor = UIColor.white
            self.suffleButton.isHidden = true
        }
        
    }
    
    @IBAction func luckButton(_ sender: UIButton) -> Void{
        nameIsEmpty()
    }
    
    func nameIsEmpty() -> Void {
        if validateForm() == true {
            self.view.endEditing(true)
            
            nameHouse.shuffle()
            self.nameTextField.isHidden = true
            self.infoLabel.isHidden = true
            self.houseSelected = nameHouse.first ?? ""
            self.viewMain.firstColor = self.backgroundColor(name: nameHouse.first ?? "")
            self.viewSuccess.isHidden = false
            self.houseLabel.text = "\(nameHouse.first ?? "")"
            self.houseLabel.textColor = UIColor.white
            self.suffleButton.isHidden = true
        
            saveHouse()
        }
    }
    
    func backgroundColor(name: String) -> UIColor {
        myHouse = name
        
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
    
    func saveHouse() {
        
        UserDefaults.standard.set(nameHouse.first, forKey: "myHouse")
    }
}

private extension HatViewController {
    
    func setupUI() {
        title = "Chapéu Seletor"
        titleLabel.isHidden = true
        closeButton.isHidden = true
        suffleButton.layer.cornerRadius = suffleButton.frame.height / 2
        nameTextField.setEditingColor()
        nameTextField.delegate = self
    }
    
    func validateForm() -> Bool {
        let status = nameTextField.text!.isEmpty
        
        if status {
            nameTextField.setErrorColor()
            infoLabel.textColor = .systemRed
            infoLabel.text = "Preencha um nome"
            return false
        }
        return true
    }
       
    @IBAction func emailBeginEditing(_ sender: Any) {
        nameTextField.setEditingColor()
        infoLabel.textColor = .gray
        infoLabel.text = "Informe seu nome"
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        nameTextField.setEditingColor()
        
        infoLabel.textColor = .gray
        infoLabel.text = "Informe seu nome"
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
        nameTextField.setEditingColor()
    }
}

//MARK: - TextField properties
extension HatViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nameTextField {
            nameTextField.resignFirstResponder()
        }
        return true
    }
}

