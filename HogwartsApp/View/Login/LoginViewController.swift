//
//  LoginViewController.swift
//  HogwartsApp
//
//  Created by Elena Diniz on 22/08/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var contentView: GradientView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var erroEmailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var recoveryPasswordButton: UIButton!
    
    var showPassword = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        //Buttom personalization
        self.loginButton.layer.cornerRadius = loginButton.layer.frame.height / 2
        self.loginButton.layer.borderWidth = 1
        
        //TextField personalization
        erroEmailLabel.isHidden = true
        emailTextField.delegate = self
        emailTextField.setEditingColor()
        passwordTextField.setEditingColor()
        passwordTextField.delegate = self
    }
    
    @IBAction func tappedRecoveryPasswordButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PasswordRecoveryViewController") as! PasswordRecoveryViewController
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        if validateForm() == true {
            do {
                let email = emailTextField.text ?? ""
                let password = passwordTextField.text ?? ""
                
                FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    let userEmail = Auth.auth().currentUser?.email
                    
                    if error == nil {
                        print("usuário logado no Firebase")
                        strongSelf.continueToHome()
                    } else {
                        if email != userEmail {
                            strongSelf.passwordTextField.setErrorColor()
                            strongSelf.emailTextField.setErrorColor()
                            strongSelf.erroEmailLabel.isHidden = false
                            strongSelf.erroEmailLabel.text = "Conta não encontrada! Verifique os dados informados ou cadastre-se"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func tappedShowPasswordButton(_ sender: Any) {
        
        if(showPassword == true) {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(named: "eye.slashed.fill"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(named: "eye.fill"), for: .normal)
        }
        showPassword = !showPassword
    }
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
        return false
    }
    
    fileprivate func validateForm() -> Bool {
        if emailTextField.text!.isEmpty ||
            !emailTextField.text!.contains(".") ||
            !emailTextField.text!.contains("@") ||
            emailTextField.text!.count <= 5 {
            emailTextField.setErrorColor()
            self.erroEmailLabel.isHidden = false
            self.erroEmailLabel.text = "Verifique o e-mail informado"
            return false
        }
        
        if passwordTextField.text!.isEmpty ||
            passwordTextField.text!.count < 5 {
            passwordTextField.setErrorColor()
            self.erroEmailLabel.isHidden = false
            self.erroEmailLabel.text = "Verifique a senha informada"
            return false
        }
        
        return true
    }
    
    fileprivate func continueToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .fullScreen
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
}

//MARK: - TextField properties
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
