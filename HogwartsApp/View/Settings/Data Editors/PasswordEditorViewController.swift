//
//  PasswordEditorViewController.swift
//  HogwartsApp
//
//  Created by Elena Diniz on 20/10/21.
//

import UIKit
import FirebaseAuth

class PasswordEditorViewController: UIViewController {
    
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var confirmationEmailLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var changePasswordButton: ButtonGradient!
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

    @IBAction func tappedChangePasswordButton(_ sender: UIButton) {
        if validateForm() {
            self.view.endEditing(true)
            guard let emailUser = self.emailTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
            
            self.resetPassword(email: emailUser) {
                self.emailTextField.isHidden = true
                self.infoLabel.isHidden = true
                self.viewSuccess.isHidden = false
                self.emailLabel.text = self.emailTextField.text?.trimmingCharacters(in: .whitespaces)
                self.changePasswordButton.setTitle("REENVIAR EMAIL", for: .normal)
            } erro: {
                ServiceError.failure
            }
        }
    }
    
    func resetPassword(email: String, success: @escaping () -> Void, erro: @escaping () -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                print("Email de redefinição enviado para o usuário")
                success()
            } else {
                erro()
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

extension PasswordEditorViewController {
    
    fileprivate func setupView() {
        changePasswordButton.layer.cornerRadius = changePasswordButton.bounds.height / 2
        closeButton.isHidden = true
        titleLabel.isHidden = true
        title = "Alteração de Senha"
        emailTextField.setEditingColor()
        emailTextField.delegate = self
        
        if !email.isEmpty {
            emailTextField.text = email
            emailTextField.isEnabled = false
        }
    }
    
    @IBAction func emailBeginEditing(_ sender: Any) {
        emailTextField.setEditingColor()
        infoLabel.textColor = .gray
        infoLabel.text = "Informe o e-mail associado à sua conta"
    }
    
    @IBAction func emailEditing(_ sender: Any) {
        emailTextField.setEditingColor()
        
        infoLabel.textColor = .gray
        infoLabel.text = "Informe o e-mail associado à sua conta"
    }
    
    @IBAction func emailEndEditing(_ sender: Any) {
        emailTextField.setEditingColor()
    }
}

//MARK: - TextField properties
extension PasswordEditorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            emailTextField.resignFirstResponder()
        }
        return true
    }
}
