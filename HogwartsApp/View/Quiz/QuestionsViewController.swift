//
//  QuestionsViewController.swift
//  HogwartsApp
//
//  Created by Maysa on 29/09/21.
//

import UIKit
import PopupDialog

class QuestionsViewController: UIViewController {

    @IBOutlet weak var questionQuiz: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var feedbackView: UIView!
    @IBOutlet weak var labelFeedback: UILabel!
    @IBOutlet weak var buttonFeedback: UIButton!


    private var alert: Alert?
    var questions:[Question]!
    var currentQuestion = 0
    var grade = 0.0
    var quizEnded = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.alert = Alert(viewController: self)
        loadQuestions()
        startQuiz()
        // Do any additional setup after loading the view.
        title = "Quiz"
        buttonFeedback.layer.cornerRadius = buttonFeedback.frame.height / 2
    }

    func loadQuestions() -> Void {
        let question1 = Question(
            question: "Como a Lilian morreu?",
            answers: [
                Answer(answer: "Assassinada por Voldermort", isRight: true),
                Answer(answer: "Harry acabou a matando sem querer", isRight: false),
                Answer(answer: "Morreu no parto do Harry", isRight: false),
                Answer(answer: "Morreu na guerra Bruxa", isRight: false)
            ]

        )

        let question2 = Question(
            question: "A qual casa o Harry Potter pertence?",
            answers: [
                Answer(answer: "Grifinória", isRight: true),
                Answer(answer: "Sonserina", isRight: false),
                Answer(answer: "Lufa-Lufa", isRight: false),
                Answer(answer: "Corvinal", isRight: false)
            ]

        )

        let question3 = Question(
            question: "Quem matou Dumbledore?",
            answers: [
                Answer(answer: "Severo Snape", isRight: true),
                Answer(answer: "Harry Potter", isRight: false),
                Answer(answer: "Rony", isRight: false),
                Answer(answer: "Draco Malfoy", isRight: false)
            ]

        )

        let question4 = Question(
            question: "Com quantos anos Harry foi pra Hogwarts?",
            answers: [
                Answer(answer: "11", isRight: true),
                Answer(answer: "12", isRight: false),
                Answer(answer: "9", isRight: false),
                Answer(answer: "17", isRight: false)
            ]

        )

        let question5 = Question(
            question: "Quais os nomes dos pais de Harry?",
            answers: [
                Answer(answer: "Thiago e Lilian", isRight: true),
                Answer(answer: "João e Maria", isRight: false),
                Answer(answer: "Gina e Rony", isRight: false),
                Answer(answer: "Cedrico e Hermione", isRight: false)
            ]

        )

        let question6 = Question(
            question: "Com quantos anos Dumbledore morreu?",
            answers: [
                Answer(answer: "150", isRight: true),
                Answer(answer: "200", isRight: false),
                Answer(answer: "110", isRight: false),
                Answer(answer: "90", isRight: false)
            ]

        )

        let question7 = Question(
            question: "Qual nome completo do Harry?",
            answers: [
                Answer(answer: "Harry James Potter", isRight: true),
                Answer(answer: "Harry Potter", isRight: false),
                Answer(answer: "Harry J. Potter", isRight: false),
                Answer(answer: "James Potter", isRight: false)
            ]

        )

        let question8 = Question(
            question: "Qual nome do irmão de Dumbledore?",
            answers: [
                Answer(answer: "Aurelius Dumbledore", isRight: true),
                Answer(answer: "James Dumbledore", isRight: false),
                Answer(answer: "Harry J. Potter", isRight: false),
                Answer(answer: "Ronie", isRight: false)
            ]

        )

        let question9 = Question(
            question: "Qual o nome dos melhores amigos do Harry?",
            answers: [
                Answer(answer: "Rony e Hermione", isRight: true),
                Answer(answer: "James Dumbledore e Severo", isRight: false),
                Answer(answer: "Draco e Voldermort", isRight: false),
                Answer(answer: "Cedrico e Dumbledore", isRight: false)
            ]

        )

        let question10 = Question(
            question: "Quantas Horcrux Voldermort criou?",
            answers: [
                Answer(answer: "7", isRight: true),
                Answer(answer: "3", isRight: false),
                Answer(answer: "6", isRight: false),
                Answer(answer: "9", isRight: false)
            ]

        )


        self.questions = [
            question1,
            question2,
            question3,
            question4,
            question5,
            question6,
            question7,
            question8,
            question9,
            question10
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func answer1(_ sender: Any) {

        selectAnswer(0)

    }

    @IBAction func answer2(_ sender: Any) {

        selectAnswer(1)
    }

    @IBAction func answer3(_ sender: Any) {

        selectAnswer(2)
    }

    @IBAction func answer4(_ sender: Any) {

        selectAnswer(3)

    }

    func startQuiz() -> Void {
        questions.shuffle()

        for i in 0 ..< questions.count {
            questions[i].answers.shuffle()
        }

        quizEnded = false
        grade = 0.0
        currentQuestion = 0
        feedbackView.isHidden = true

        showQuestion(0)
    }

    func showQuestion(_ questionId : Int) -> Void {
        enableButtons()

        let selectedQuestion : Question = questions[questionId]
        questionQuiz.text = selectedQuestion.question


        option1.setTitle(selectedQuestion.answers[0].response, for: UIControl.State())
        option2.setTitle(selectedQuestion.answers[1].response, for: UIControl.State())
        option3.setTitle(selectedQuestion.answers[2].response, for: UIControl.State())
        option4.setTitle(selectedQuestion.answers[3].response, for: UIControl.State())
    }

    func disableButtons() -> Void {
        option1.isEnabled = false
        option2.isEnabled = false
        option3.isEnabled = false
        option4.isEnabled = false
        questionQuiz.isHidden = true
    }

    func enableButtons() -> Void {
        option1.isEnabled = true
        option2.isEnabled = true
        option3.isEnabled = true
        option4.isEnabled = true
        questionQuiz.isHidden = false
    }

    func selectAnswer(_ answerId : Int) -> Void {
        disableButtons()

        let answer : Answer = questions[currentQuestion].answers[answerId]

        if (true == answer.isRight) {
            grade += 1.0
            labelFeedback.text = ("Resposta correta!")
            feedbackView.isHidden = true
            labelFeedback.textColor = UIColor.green


        } else {

            feedbackView.isHidden = true
            labelFeedback.text = ("Resposta incorreta!")
            labelFeedback.textColor = UIColor.red
        }

        if (currentQuestion < questions.count - 1) {
            buttonFeedback.setTitle("Próxima", for: UIControl.State())
        } else {
            buttonFeedback.setTitle("Ver pontuação", for: UIControl.State())
        }

        feedbackView.isHidden = false
    }

    @IBAction func pressFeedback(_ sender: AnyObject) {
        feedbackView.isHidden = true

        if (true == quizEnded) {
            startQuiz()
        } else {
            nextQuestion()
        }
    }

    func nextQuestion() {
        currentQuestion += 1

        if (currentQuestion < questions.count) {
            showQuestion(currentQuestion)
        } else {
            endQuiz()
        }
    }

    func endQuiz() {
        grade = grade / Double(questions.count) * 100.0
        quizEnded = true
        feedbackView.isHidden = false

        //feedbackView.backgroundColor = UIColor.gray
        labelFeedback.textColor = UIColor.white

        self.alert?.detailAlert(titulo: "Parabéns! Você concluiu o Quiz!", mensagem: "Sua pontuação foi: \(round(grade))", completion: { success in


            print("clicou no ok do botao alert")
        })

        print("error")
        labelFeedback.text = "Fim do Quiz"
        buttonFeedback.setTitle("Refazer", for: UIControl.State())
    }

    @IBAction func back(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
    
}
