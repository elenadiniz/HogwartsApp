//
//  ViewController.swift
//  HogwartsApp
//
//  Created by Elena Diniz on 05/10/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var homeCollection: UICollectionView!
    @IBOutlet var viewMain: GradientView!
    
    private var homeImageIcon = ["character_icon", "beast_icon", "quiz_icon", "hat"]
    private var homeNameIcon = ["Personagens", "Animais Fantásticos", "Quiz", "Chapéu Seletor"]
    private let imageView = UIImageView(image: UIImage(named: "profile_icon"))
    
    
    override func viewDidAppear(_ animated: Bool) { getImageUser() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeCollection.delegate = self
        homeCollection.dataSource = self
        homeCollection.register(UINib(nibName: "ButtonCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ButtonCollectionCell")
        // Do any additional setup after loading the view.
        
        setupUI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action:#selector(imageTapped(tapGestureRecognizer:))
        )
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Home"
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let userVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        userVC.providesPresentationContextTransitionStyle = true
        userVC.definesPresentationContext = true
        navigationController?.pushViewController(userVC, animated: true)
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
                    self.imageView.image = myImage
                }
            }
        }
    }
}

//MARK: -Collection Properties
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeNameIcon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ButtonCollectionCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionCell", for: indexPath) as? ButtonCollectionCell
        
        cell?.iconImageView.image = UIImage(named: homeImageIcon[indexPath.row])
        cell?.nameLabel.text = homeNameIcon[indexPath.row]
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let navigationChoosed = homeNameIcon[indexPath.row]
        
        if navigationChoosed == "Personagens" {
            let storyboard = UIStoryboard(name: "Characters", bundle: nil)
            let charactersVC = storyboard.instantiateViewController(withIdentifier: "CharactersViewController") as! CharactersViewController
            charactersVC.providesPresentationContextTransitionStyle = true
            charactersVC.definesPresentationContext = true
            navigationController?.pushViewController(charactersVC, animated: true)
        } else if navigationChoosed == "Animais Fantásticos" {
            let storyboard = UIStoryboard(name: "Beasts", bundle: nil)
            let beastsVC = storyboard.instantiateViewController(withIdentifier: "BeastsViewController") as! BeastsViewController
            beastsVC.providesPresentationContextTransitionStyle = true
            beastsVC.definesPresentationContext = true
            navigationController?.pushViewController(beastsVC, animated: true)
        } else if navigationChoosed == "Quiz" {
            let storyboard = UIStoryboard(name: "Quiz", bundle: nil)
            let quizVC = storyboard.instantiateViewController(withIdentifier: "QuizViewController") as! QuizViewController
            quizVC.providesPresentationContextTransitionStyle = true
            quizVC.definesPresentationContext = true
            navigationController?.pushViewController(quizVC, animated: true)
        } else if navigationChoosed == "Chapéu Seletor" {
            let storyboard = UIStoryboard(name: "Hat", bundle: nil)
            let hatVC = storyboard.instantiateViewController(withIdentifier: "HatViewController") as! HatViewController
            hatVC.providesPresentationContextTransitionStyle = true
            hatVC.definesPresentationContext = true
            navigationController?.pushViewController(hatVC, animated: true)
        }
    }
}
