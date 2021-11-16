//
//  AppDelegate.swift
//  HogwartsApp
//
//  Created by Elena Diniz on 05/10/21.
//

import UIKit
import Firebase
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
        
//        let authListener = Auth.auth().addStateDidChangeListener { auth, user in
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let userStoryboard = UIStoryboard(name: "User", bundle: nil)
//
//            if user != nil {
//                let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
//                self.window?.rootViewController = controller
//                self.window?.makeKeyAndVisible()
//            } else {
//                let home = userStoryboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//                self.window?.rootViewController = home
//                self.window?.makeKeyAndVisible()
//            }
//        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

     var window: UIWindow?
    
    func changeRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard let window = self.window else {
            return
        }
        // change the root view controller to your specific view controller
        window.rootViewController = vc
    }
}
