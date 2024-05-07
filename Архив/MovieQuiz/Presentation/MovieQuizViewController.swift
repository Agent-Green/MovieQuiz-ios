import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{
    
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    
    @IBOutlet private weak var indexLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var imageUI: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter : AlertPresenter?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 24)
        
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 24)
        
        alertPresenter = AlertPresenter(delegate: self)
        
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        
        questionFactory.requestNextQuestion()
        
        super.viewDidLoad()
    }
    
    // MARK: - Private functions
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        
        let result = QuizStepViewModel(
            image : UIImage(named: model.image) ?? UIImage(),
            question : model.text,
            questionNumber : "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
        return result
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        
        indexLabel.text = step.questionNumber
        imageUI.image = step.image
        questionLabel.text = step.question
        
    }
    
    //    private func show(quiz result: QuizResultsViewModel){
    //
    //        let alertModel = AlertModel(
    //            title: result.title,
    //            message: result.text,
    //            buttonText: result.buttonText,
    //            completion: {[weak self] in
    //                guard let self = self else {return}
    //                self.currentQuestionIndex = 0
    //                self.correctAnswers = 0
    //                self.questionFactory?.requestNextQuestion()
    //
    //            }
    //        )
    //
    //        alertPresenter?.showAlert(model: alertModel)
    //    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageUI.layer.masksToBounds = true
        imageUI.layer.borderWidth = 8
        
        if isCorrect{
            imageUI.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageUI.layer.borderColor = UIColor.ypRed.cgColor
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
            
        }
        
    }
    private func showNextQuestionOrResults() {
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        imageUI.layer.borderWidth = 0
        
        if currentQuestionIndex == questionsAmount - 1{
            
            let message = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: message,
                buttonText: "Сыграть ещё раз",
                completion: { [weak self] in
                    guard let self else { return }
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    questionFactory?.requestNextQuestion()
                })
            alertPresenter?.showAlert(model: alertModel)
            
            
            
        } else {
            currentQuestionIndex += 1
            
            self.questionFactory?.requestNextQuestion()
            
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        
        guard let currentQuestion = currentQuestion else {return}
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        
        guard let question = question else {return}
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    
    
    
    
}

