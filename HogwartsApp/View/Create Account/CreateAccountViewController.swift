//
//  SignInViewController.swift
//  HogwartsApp
//
//  Created by Elena Diniz on 22/08/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CryptoKit

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var contentView: GradientView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var bdayLabel: UILabel!
    @IBOutlet weak var bdayTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var confirmEmailLabel: UILabel!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var showConfirmPasswordButton: UIButton!
    @IBOutlet weak var signInButton: ButtonGradient!
    
    
    var showPassword = true
    var showConfirmPassword = true
    var arrayPaises: [String] = ["Brasil", "Angola", "Portugal", "Mexico", "USA"]
    var pickerCountry = UIPickerView()
    var datePicker = UIDatePicker()
    
    var ref: DatabaseReference!
    var userData: UserData!
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        self.pickerCountry.delegate = self
        self.pickerCountry.dataSource = self
        createDatePicker()
    }
    
    func createDatePicker() {
        //toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //ToolBar Button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneButton], animated: true)
        
        //ToolBar Assign
        bdayTextField.inputAccessoryView = toolBar
        
        //Mode
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        //Assinging the datePicker to the TextField
        bdayTextField.inputView = datePicker
    }
    
    @objc func donePressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        bdayTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func setupView() {
        //Button properties
        self.signInButton.layer.cornerRadius = signInButton.layer.frame.height / 2
        self.signInButton.layer.borderWidth = 1
        
        //TextField personalization properties
        emailTextField.setEditingColor()
        confirmEmailTextField.setEditingColor()
        passwordTextField.setEditingColor()
        confirmPasswordTextField.setEditingColor()
        nameTextField.setEditingColor()
        bdayTextField.setEditingColor()
        countryTextField.setEditingColor()
        
        //PickerView properties
        self.countryTextField.inputView = self.pickerCountry
    }
    
    @IBAction func tappedCloseButton(_ sender: UIButton) {
        
        self.dismiss(animated: true)
    }
    
    @IBAction func didTappedShowPassword(_ sender: UIButton) {
        
        if(showPassword == true) {
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(systemName: "eye.slashed.fill"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        showPassword = !showPassword
    }
    
    @IBAction func didTappedConfirmShowPassword(_ sender: UIButton) {
        
        if(showPassword == true) {
            confirmPasswordTextField.isSecureTextEntry = false
            showConfirmPasswordButton.setImage(UIImage(systemName: "eye.slashed.fill"), for: .normal)
        } else {
            confirmPasswordTextField.isSecureTextEntry = true
            showConfirmPasswordButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        }
        showPassword = !showPassword
    }
    
    @IBAction func tappedSignInButton(_ sender: Any) {
        if validateForm() == true {
            do {
                let email = emailTextField.text ?? ""
                let password = passwordTextField.text ?? ""
                
                FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                    guard let strongSelf = self else {
                        return
                    }
                    guard error == nil else {
                        strongSelf.showCreateAccount(email: email, password: password)
                        return
                    }
                    guard error != nil else {
                        strongSelf.errorCreateAccount()
                        return
                    }
                }
            }
        }
    }
    
    func showCreateAccount(email: String, password: String) {
        
        let alert = UIAlertController(title: "PARABÉNS!", message: "Sua conta foi criada com sucesso", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Continuar", style: .default) { _ in
            
            let name = self.nameTextField.text ?? ""
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                guard let strongSelf = self else {
                    return
                }
                guard error == nil && result != nil else {
                    print("Usuário criado no Firebase")
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    
                    changeRequest?.commitChanges(completion: { error in
                        if error == nil {
                            print("User name saved")
                            self?.dismiss(animated: false, completion: nil)
                        } else {
                            print("Erro: \(String(describing: error?.localizedDescription))")
                        }
                    })
                    return
                }
                strongSelf.continueToHome()
                strongSelf.createUserDataInDatabase()
            }
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorCreateAccount() {
        let alert = UIAlertController(title: "ATENÇÃO!", message: "Erro ao criar conta, confira os dados e tente novamente!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Okay", style: .default) { _ in
            self.nameErrorLabel.text = "REVISE SUAS INFORMAÇÕES"
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func continueToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .fullScreen
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    func createUserDataInDatabase() {
        let db = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        let currentUser = Auth.auth().currentUser
        
        if (currentUser != nil) {
            self.email = currentUser?.email ?? ""
        }
        
        ref = db.child("users")
        
        let obj = ref.child(userID!)
        print("UserID saved in Database", obj)
        
        obj.observe(DataEventType.value, with: {(userData) in
            let value = userData.value
            print("UserData is Nil", value is NSNull)
            
            do {
                if (value is NSNull) {
                    self.sendUserEmailToDatabase(email: self.email)
                    self.sendUserNameToDatabase(userName: self.nameTextField.text!)
                    self.sendUserCountryToDataBase(userCountry: self.countryTextField.text!)
                    self.sendUserBdayDateToDatabase(userBdayDate: self.bdayTextField.text!)
                } else {
                    let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [])
                    self.userData = try JSONDecoder().decode(UserData.self, from: jsonData)
                    
                    if (self.userData != nil) {
                        self.setLabels(userData: self.userData)
                    }
                }
            } catch _ {
                print(ServiceError.failure)
            }
        })
    }
    
    private func setLabels(userData: UserData) {
        self.nameTextField.text = userData.usersName
        self.bdayTextField.text = userData.userBdayDate
        self.countryTextField.text = userData.userCountry
    }
    
    private func sendUserNameToDatabase(userName: String) {
        let userID = Auth.auth().currentUser?.uid
        ref.child(userID!).child("usersName").setValue(userName)
    }
    
    private func sendUserBdayDateToDatabase(userBdayDate: String) {
        let userID = Auth.auth().currentUser?.uid
        ref.child(userID!).child("userBdayDate").setValue(userBdayDate)
    }
    
    private func sendUserCountryToDataBase(userCountry: String) {
        let userID = Auth.auth().currentUser?.uid
        ref.child(userID!).child("userCountry").setValue(userCountry)
    }
    
    private func sendUserEmailToDatabase(email: String) {
        let userID = Auth.auth().currentUser?.uid
        ref.child(userID!).child("userEmail").setValue(email)
    }
    
    fileprivate func validateForm() -> Bool {
        if nameTextField.text!.isEmpty {
            nameTextField.setErrorColor()
            nameErrorLabel.text = "É necessário fornecer o nome completo"
            return false
        } else {
            let fullNameArr = nameTextField.text!.components(separatedBy: " ")
            if fullNameArr.count <= 1 {
                nameTextField.setErrorColor()
                nameErrorLabel.text = "É necessário fornecer o nome completo"
                return false
            }
        }
        
        if emailTextField.text!.isEmpty ||
            !emailTextField.text!.contains(".") ||
            !emailTextField.text!.contains("@") ||
            emailTextField.text!.count <= 5 {
            emailTextField.setErrorColor()
            emailErrorLabel.text = "E-mail inválido."
            return false
        }
        
        if confirmEmailTextField.text!.isEmpty ||
            !confirmEmailTextField.text!.contains(".") ||
            !confirmEmailTextField.text!.contains("@") ||
            confirmEmailTextField.text!.count <= 5 {
            confirmEmailTextField.setErrorColor()
            emailErrorLabel.text = "E-mail inválido."
            return false
        }
        
        if confirmEmailTextField.text?.trimmingCharacters(in: .whitespaces) != emailTextField.text?.trimmingCharacters(in: .whitespaces) {
            emailTextField.setErrorColor()
            confirmEmailTextField.setErrorColor()
            emailErrorLabel.text = "E-mails devem ser iguais."
            return false
        }
        
        if passwordTextField.text!.isEmpty ||
            passwordTextField.text!.count < 6 {
            passwordTextField.setErrorColor()
            passwordErrorLabel.text = "Verifique a senha informada, ela deverá ter no mínimo 6 caracteres."
            return false
        }
        
        if confirmPasswordTextField.text!.isEmpty ||
            confirmPasswordTextField.text!.count < 6 {
            confirmPasswordTextField.setErrorColor()
            passwordErrorLabel.text = "Verifique a senha informada, ela deverá ter no mínimo 6 caracteres."
            return false
        }
        
        if confirmPasswordTextField.text != passwordTextField.text {
            passwordTextField.setErrorColor()
            confirmPasswordTextField.setErrorColor()
            passwordErrorLabel.text = "Senhas devem ser iguais."
            return false
        }
        return true
    }
}

//MARK: - PickerView properties
extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerCountry:
            return self.arrayPaises.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerCountry:
            return self.arrayPaises[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerCountry:
            self.countryTextField.text = String(arrayPaises[row])
            self.countryTextField.resignFirstResponder()
        default:
            print("Caiu no Default")
        }
    }
}
