//
//  ViewController.swift
//  HogwartsApp
//
//  Created by Elena Diniz on 22/08/21.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var logoImageVIew: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loginButton.layer.cornerRadius = loginButton.layer.frame.height / 2
        self.loginButton.layer.borderWidth = 1
        userDidLogin()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        userDidLogin()
    }

    @IBAction func tappedLoginButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func tappedSignInButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func userDidLogin() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(controller)
            } else {
                let userStoryboard = UIStoryboard(name: "User", bundle: nil)
                let home = userStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                home.providesPresentationContextTransitionStyle = true
                home.definesPresentationContext = true
                self.present(home, animated: true, completion: nil)
            }
        }
    }
}

