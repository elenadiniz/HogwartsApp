//
//  EmailEditorViewController.swift
//  HogwartsApp
//
//  Created by Elena Diniz on 20/10/21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class EmailEditorViewController: UIViewController {
    
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var confirmationEmailLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var changeEmailButton: ButtonGradient!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tappedChangeEmailButton(_ sender: UIButton) {
        if validateForm() == true {
            self.view.endEditing(true)
            guard let emailUser = self.emailTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
            
            self.changeEmail(email: emailUser) { (success) in
                if success {
                    self.emailTextField.isHidden = true
                    self.infoLabel.isHidden = true
                    self.viewSuccess.isHidden = false
                    self.emailLabel.text = self.emailTextField.text?.trimmingCharacters(in: .whitespaces)
                    self.changeEmailButton.isHidden = true
                }
            }
        } else {
            print(ServiceError.wrongEmailOrPassword)
        }
    }
    
    func changeEmail(email: String, completion: @escaping (Bool) -> Void) {
        let db = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        let userEmail = Auth.auth().currentUser?.email
        let currentUser = Auth.auth().currentUser
        if emailTextField.text != nil {
            db.child("users").child(userID!).updateChildValues(["userEmail" : emailTextField.text!])
            if emailTextField.text != userEmail {
                currentUser?.updateEmail(to: emailTextField.text ?? "") { erro in
                    if let error = erro {
                        print("Erro ao alterar email. \(String(describing: error))")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
    
    fileprivate func validateForm() -> Bool {
        let status = emailTextField.text!.isEmpty ||
        !emailTextField.text!.contains(".") ||
        !emailTextField.text!.contains("@") ||
        emailTextField.text!.count <= 5
        
        if status {
            emailTextField.setErrorColor()
            infoLabel.textColor = .systemRed
            infoLabel.text = "Verifique o e-mail informado"
            return false
        }
        
        return true
    }
}

extension EmailEditorViewController {
    
    fileprivate func setupView() {
        changeEmailButton.layer.cornerRadius = changeEmailButton.bounds.height / 2
        closeButton.isHidden = true
        emailTextField.setEditingColor()
        titleLabel.isHidden = true
        title = "Alteração de E-mail"
        if !email.isEmpty {
            emailTextField.text = email
            emailTextField.isEnabled = false
        }
    }
    
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextField.setEditingColor()
        infoLabel.textColor = .gray
        infoLabel.text = "Informe o novo e-mail de sua conta"
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        emailTextField.setEditingColor()
        
        infoLabel.textColor = .gray
        infoLabel.text = "Informe o novo e-mail de sua conta"
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextField.setEditingColor()
    }
}

