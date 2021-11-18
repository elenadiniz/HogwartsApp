//
//  Alert.swift
//  HogwartsApp
//
//  Created by Maysa on 01/10/21.
//

import UIKit
import PopupDialog

class Alert {
    
    var controller:UIViewController
    
    init(viewController:UIViewController) {
        self.controller = viewController
    }
    
    func showPopup(completion:@escaping() -> Void) {
        
        let title: String = "Resultado da resposta"
        let msg: String = "certa ou errada?"
        let image = UIImage(named: "happy_harry")
        
        
        let popup: PopupDialog = PopupDialog(title: title, message: msg, image: image)
        
        popup.view.backgroundColor = .black
        
        let button = DefaultButton(title: "OK") {
            
            print("clicou no OK")
            
            completion()
        }
        
        button.backgroundColor = UIColor(cgColor: CGColor(red: 75/255.0, green: 162/255.0, blue: 218/255.0, alpha: 1))
        button.titleColor = .white
        
        popup.addButton(button)
        
        self.controller.present(popup, animated: true, completion: nil)
        
    }
 
    func showAlert(titulo:String, mensagem:String, tituloBotao:String){
        //configura meu alert
        let alert:UIAlertController = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        //configura a ação dos botões
        let ok:UIAlertAction = UIAlertAction(title: tituloBotao, style: .cancel, handler: nil)
        //configura o botão (ação) no alert
        alert.addAction(ok)
        //apresenta meu alert
        controller.present(alert, animated: true, completion: nil)
    }
    
    func detailAlert(titulo:String, mensagem:String, completion:@escaping(_ value: Bool) -> Void) {
        
        let title = titulo
        let message = mensagem
        let image = UIImage(named: "happy_harry")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image)
        popup.view.backgroundColor = .black
        // Create buttons
        let buttonOne = DefaultButton(title: "OK") {
            print("You canceled the car dialog.")
            
          completion(true)
        }
        
        buttonOne.backgroundColor = UIColor(cgColor: CGColor(red: 75/255.0, green: 162/255.0, blue: 218/255.0, alpha: 1))
        buttonOne.titleColor = .white
        popup.addButtons([buttonOne])

        // Present dialog
        self.controller.present(popup, animated: true, completion: nil)
        

    }
    
}
