//
//  SettingsViewController.swift
//  HogwartsApp
//
//  Created by Elena Diniz on 11/10/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseUI
import SDWebImage

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var viewMain: GradientView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var changeProfileImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var houseView: UIView!
    @IBOutlet weak var houseLogoImageView: UIImageView!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var settingsTableView: UITableView!
    
    var imagePicker: UIImagePickerController!
    var buttonName = ["Dados Pessoais", "E-mail", "Senha", "Sair"]
    var userData: UserData!
    
    private let imageView = UIImageView(image: UIImage(named: "profile_icon"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let value = UserDefaults.standard.string(forKey: "myHouse")
        houseNameLabel.text = value
        setupUI()
        getUserData()
        colorLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getImageUser()
        colorLabel()
    }
    
    private func setupUI() {
        if view.frame.width <= 375 {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        title = "Perfil"
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        nameLabel.isHidden = true
        houseView.layer.cornerRadius = 5
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.frame = view.bounds
        settingsTableView.register(UINib(nibName: "ButtonTableCell", bundle: nil), forCellReuseIdentifier: "ButtonTableCell")
    }
    
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 40
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 16
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 12
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
    @objc func openImagePicker(_ sender:Any) {
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func tappedChangeProfileImageButton(_ sender: UIButton) {
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    private func alertLogOut() {
        let alert = UIAlertController(title: "ATENÇÃO!", message: "Deseja realmente deslogar de sua conta?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Continuar", style: .default) { _ in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                print("Usuário deslogado")
                self.continueToLogin()
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func continueToLogin() {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
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
    
    func setLabels(userData: UserData) {
        nameLabel.isHidden = false
        self.nameLabel.text = userData.usersName
    }
    
    func uploadImage(imageUrl: URL) {
        do {
            guard let user = Auth.auth().currentUser else { return }
            let uid = user.uid
            let fileExtension = imageUrl.pathExtension
            let fileName = uid
            let metaData = StorageMetadata()
            let storageReference = Storage.storage().reference().child(fileName)
            let currentUploadTask = storageReference.putFile(from: imageUrl, metadata: metaData) { (storageMetaData, error) in
                
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    return
                }
                
                print("Image file: \(fileName) is uploaded! View it at Firebase console!")
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.photoURL = imageUrl
                changeRequest.commitChanges { error in
                    if error != nil {
                        self.saveImageDatabase(profileImageURL: imageUrl) { success in
                            if success {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
                
                storageReference.downloadURL { (url, error) in
                    if let error = error  {
                        print("Error on getting download url: \(error.localizedDescription)")
                        return
                    }
                    print("Download url of \(fileName) is \(url!.absoluteString)")
                }
            }
        } catch {
            print("Error on extracting data from url: \(error.localizedDescription)")
        }
    }
    
    func saveImageDatabase(profileImageURL: URL, completion: @escaping ((_ success: Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users").child(uid)
        
        let userObject = [
            "photoURL": profileImageURL.absoluteString
        ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    func getImageUser() {
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        let storageReference = Storage.storage().reference().child(uid)
        
        storageReference.getData(maxSize: (15 * 9999 * 9999)) { (data, error) in
            if let err = error {
            } else {
                if let image  = data {
                    let myImage: UIImage! = UIImage(data: image)
                    self.profileImageView.image = myImage
                    self.imageView.image = myImage
                }
            }
        }
    }
    
    func colorLabel() -> Void {
        if houseNameLabel.text == "Grifinória" {
            houseView.backgroundColor = UIColor(red: 0.48, green: 0.04, blue: 0.08, alpha: 1.00)
            houseLogoImageView.image = UIImage(named: "gryffindor")
        } else if houseNameLabel.text == "Lufa-lufa" {
            houseView.backgroundColor = UIColor(red: 0.95, green: 0.69, blue: 0.10, alpha: 1.00)
            houseLogoImageView.image = UIImage(named: "hufllepuff")
        } else if houseNameLabel.text == "Corvinal" {
            houseView.backgroundColor = UIColor (red: 0.20, green: 0.32, blue: 0.52, alpha: 1.00)
            houseLogoImageView.image = UIImage(named: "ravenclaw")
        } else if houseNameLabel.text == "Sonserina" {
            houseView.backgroundColor = UIColor(red: 0.03, green: 0.24, blue: 0.14, alpha: 1.00)
            houseLogoImageView.image = UIImage(named: "slytherin")
        } else {
            houseNameLabel.text = "Bem-vindo(a)"
            houseView.backgroundColor = UIColor(red: 0.694, green: 0.561, blue: 0.294, alpha: 1)
        }
    }
}

//MARK: - ImagePicker Delegate
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = editedImage
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                self.uploadImage(imageUrl: imageURL)
            }
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - TableView DataSource and Delegate
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ButtonTableCell? = tableView.dequeueReusableCell(withIdentifier: "ButtonTableCell", for: indexPath) as? ButtonTableCell
        
        cell?.buttonName.text = buttonName[indexPath.row]
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let buttons = buttonName[indexPath.row]
        
        if buttons == "Dados Pessoais" {
            let storyboard = UIStoryboard(name: "UserSettings", bundle: nil)
            let personalData = storyboard.instantiateViewController(withIdentifier: "PersonalDataViewController") as! PersonalDataViewController
            personalData.providesPresentationContextTransitionStyle = true
            personalData.definesPresentationContext = true
            navigationController?.pushViewController(personalData, animated: true)
        } else if buttons == "E-mail" {
            let storyboard = UIStoryboard(name: "UserSettings", bundle: nil)
            let email = storyboard.instantiateViewController(withIdentifier: "EmailEditorViewController") as! EmailEditorViewController
            email.providesPresentationContextTransitionStyle = true
            email.definesPresentationContext = true
            navigationController?.pushViewController(email, animated: true)
        } else if buttons == "Senha" {
            let storyboard = UIStoryboard(name: "UserSettings", bundle: nil)
            let password = storyboard.instantiateViewController(withIdentifier: "PasswordEditorViewController") as! PasswordEditorViewController
            password.providesPresentationContextTransitionStyle = true
            password.definesPresentationContext = true
            navigationController?.pushViewController(password, animated: true)
        } else if buttons == "Sair" {
            self.alertLogOut()
        }
    }
}
