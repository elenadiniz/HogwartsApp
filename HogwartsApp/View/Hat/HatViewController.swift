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
    
    var myHouse: String = ""
    
    

    
    var nameHouse:[String] = ["Grifinória", "Sonserina","Corvinal", "Lufa-lufa"]
    
    var nameHouse:[String] = ["Grifinória", "Sonserina","Corvinal", "Lufa-lufa"]
    
    var houseSelected: String = ""
    
    var house: String = ""
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var textHouse: UILabel!
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var hatImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var suffleButton: ButtonGradient!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var suffleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.suffleButton.isHidden = false
        self.nameTextField.isHidden = false
        let value = UserDefaults.standard.string(forKey: "myHouse")
        
        
        UserDefaults.standard.signedInUser
        let house = UserDefaults.standard.myHouse
        self.textHouse.text = "Sua casa sorteada foi: \(value ?? "")"
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
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let value = UserDefaults.standard.string(forKey: "myHouse")
        
        self.viewMain.firstColor = UserDefaults.UserDefaultsKeys.myHouse.backgroundColor(name: value ?? "")
        
    }
    
    @IBAction func luckButton(_ sender: UIButton) -> Void{
    
        
       nameIsEmpty()
        
    }
    
    func nameIsEmpty()-> Void{
    
        let textName = self.nameTextField.text
        if textName!.isEmpty{
            self.suffleButton.isHidden = false
            self.textHouse.text = "Preencha um nome!"
            self.textHouse.textColor = UIColor.red
            
        }else{

            nameHouse.shuffle()
            
            self.suffleButton.isHidden = true
            self.houseSelected = nameHouse.first ?? ""
            self.viewMain.firstColor = self.backgroundColor(name: nameHouse.first ?? "")
            self.textHouse.text = "Sua casa sorteada foi: \(nameHouse.first ?? "")"
            self.textHouse.textColor = UIColor.white
            saveHouse()
            
            return self.nameTextField.isHidden = true
        }
        
    }
    
    
    func backgroundColor(name: String) -> UIColor{
        
        
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
    func saveHouse(){
        // seta a string na chave selecionada
        UserDefaults.standard.set(nameHouse.first, forKey: "myHouse")
        // recupera a string da chave
        let value = UserDefaults.standard.string(forKey: "myHouse")
    
    }
    
    func saveHouse(){
        
        let value = UserDefaults.standard.string(forKey: "myHouse")

        UserDefaults.standard.set(nameHouse.first, forKey: "myHouse")
        print("myHouse")
    }
}


