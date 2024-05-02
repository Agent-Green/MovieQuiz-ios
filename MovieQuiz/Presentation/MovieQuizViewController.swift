import UIKit

final class MovieQuizViewController: UIViewController {
    
    
    
    @IBOutlet private weak var questionLabel: UILabel!
    
    @IBOutlet private weak var questionTitleLabel: UILabel!
    
    @IBOutlet private weak var indexLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var imageUI: UIImageView!
    
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private let question : [QuizQuestion] = [
        
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
    ]
    
    
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    
    private struct QuizStepViewModel {
        var image: UIImage
        let question: String
        let questionNumber: String
    }
    
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    override func viewDidLoad() {
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 24)
        
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 24)
        
        let currentQuestion = question[currentQuestionIndex]
        
        show(quiz: convert(model: currentQuestion))
        
        
        super.viewDidLoad()
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let result = QuizStepViewModel(
            image : UIImage(named: model.image) ?? UIImage(),
            question : model.text,
            questionNumber : "\(currentQuestionIndex + 1)/\(question.count)")
        
        return result
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        
        indexLabel.text = step.questionNumber
        imageUI.image = step.image
        questionLabel.text = step.question
        
    }
    
    private func show(quiz result: QuizResultsViewModel){
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.question[self.currentQuestionIndex] // 2
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.showNextQuestionOrResults()
            
        }
        
    }
    private func showNextQuestionOrResults() {
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        imageUI.layer.borderWidth = 0
        
        if currentQuestionIndex == question.count - 1{
            
            let text = "Ваш результат: \(correctAnswers)/10"
            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            
            
        } else {
            currentQuestionIndex += 1
            
            let nextQuestion = question[currentQuestionIndex]
            let nextQuestionViewModel = convert(model: nextQuestion)
            
            show(quiz: nextQuestionViewModel)
        }
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        
        let currentQuestion = question[currentQuestionIndex]
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        
        let currentQuestion = question[currentQuestionIndex]
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        
    }
    
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
