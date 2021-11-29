//
//  QuizViewController.swift
//  HogwartsApp
//
//  Created by Daniel Washington Ignacio on 01/09/21.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var buttonGoQuiz: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonGoQuiz.layer.cornerRadius = buttonGoQuiz.layer.frame.height / 2
        self.buttonGoQuiz.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        title = "Bem-Vindo ao Quiz"
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Quiz", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "QuestionsViewController") as! QuestionsViewController
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
