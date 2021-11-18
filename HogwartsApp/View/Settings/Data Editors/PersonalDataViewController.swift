//
//  PersonalDataViewController.swift
//  HogwartsApp
//
//  Created by Elena Diniz on 20/10/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import CryptoKit
import FirebaseAuth

class PersonalDataViewController: UIViewController {
    
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var bdayTextField: UITextField!
    @IBOutlet weak var saveButton: ButtonGradient!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var arrayPaises: [String] = ["Brasil", "Angola", "Portugal", "Mexico", "USA"]
    var pickerCountry = UIPickerView()
    var datePicker = UIDatePicker()
    var ref: DatabaseReference!
    var userData: UserData!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        getUserData()
        createDatePicker()
    }
    
    func setupView() {
        saveButton.layer.cornerRadius = saveButton.layer.frame.height / 2
        saveButton.layer.borderWidth = 1
        nameTextField.setEditingColor()
        nameTextField.isEnabled = false
        bdayTextField.setEditingColor()
        bdayTextField.delegate = self
        countryTextField.setEditingColor()
        countryTextField.delegate = self
        closeButton.isHidden = true
        titleLabel.isHidden = true
        
        countryTextField.inputView = self.pickerCountry
        bdayTextField.inputView = self.datePicker
        self.pickerCountry.delegate = self
        self.pickerCountry.dataSource = self
        
        title = "Dados Pessoais"
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
    
    func getUserData() {
        let db = Database.database().reference()
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.child("users").child(userID).observe(DataEventType.value, with: { snapshot in
            do {
                if snapshot.value == nil {
                    print(ServiceError.failureReading)
                } else {
                    let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value as Any, options: [])
                    self.userData = try JSONDecoder().decode(UserData.self, from: jsonData)
                    
                    if (self.userData != nil) {
                        self.setLabels(userData: self.userData)
                    }
                }
            } catch {
                print(ServiceError.failure)
            }
        })
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tappedSaveButton(_ sender: UIButton) {
        changeUser { (success) in
            if success {
                self.nameTextField.isEnabled = false
                self.bdayTextField.text = self.bdayTextField.text?.trimmingCharacters(in: .whitespaces)
                self.countryTextField.text = self.countryTextField.text?.trimmingCharacters(in: .whitespaces)
                self.updatedData()
            } else {
                self.errorToUpdateData()
            }
        }
    }
    
    func setLabels(userData: UserData) {
        self.nameTextField.text = userData.usersName
        self.bdayTextField.text = userData.userBdayDate
        self.countryTextField.text = userData.userCountry
    }
    
    func updatedData() {
        let alert = UIAlertController(title: "ATENÇÃO!", message: "Seus dados foram atualizados com sucesso", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorToUpdateData() {
        let alert = UIAlertController(title: "ATENÇÃO!", message: "Ocorreu um erro ao atualizar seus dados. Por favor, tente novamente mais tarde!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeUser(completion: @escaping (Bool) -> Void) {
        let db = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        if countryTextField.text != nil && bdayTextField.text != nil {
            db.child("users").child(userID!).updateChildValues(["userBdayDate" : bdayTextField.text!, "userCountry" : countryTextField.text!])
        }
    }
}

//MARK: - String Properties
extension String {
    //    let hash = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
    func toMD5() -> String {
        return Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data()).map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

//MARK: - PickerView properties
extension PersonalDataViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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

extension PersonalDataViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.countryTextField {
            bdayTextField.becomeFirstResponder()
        } else {
            bdayTextField.resignFirstResponder()
        }
        return true
    }
}
