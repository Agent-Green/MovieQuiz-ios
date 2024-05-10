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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    
    private var currentQuestion: QuizQuestion?
    
    private var alertPresenter : AlertPresenter?
    
    private var statisticService : StatisticServiceProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        questionLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        
        questionTitleLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        indexLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 24)
        
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 24)
        
        alertPresenter = AlertPresenter(delegate: self)
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        questionFactory.loadData()
        
        statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
        
        super.viewDidLoad()
    }
    
    // MARK: - Private functions
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let result = QuizStepViewModel(
            image : UIImage(data: model.image) ?? UIImage(),
            question : model.text,
            questionNumber : "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
        return result
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        
        indexLabel.text = step.questionNumber
        imageUI.image = step.image
        questionLabel.text = step.question
        
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
            
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            
            let message = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)
            Рекорд: \(statisticService?.bestGame.correct ?? 0)/\(statisticService?.bestGame.total ?? 0) (\(statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%
            """
            
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
    
    private func showLoadingIndicator(){
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String){
        
        hideLoadingIndicator()
        
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз",
            completion: {[weak self] in
                guard let self = self else {return}
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            })
        alertPresenter?.showAlert(model: alertModel)
        
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
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

